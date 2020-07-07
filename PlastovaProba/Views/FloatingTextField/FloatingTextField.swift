//
//  FloatingTextField.swift
//  FloatingTextField
//
//  Created by Pavlo Dumyak on 29.06.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

protocol FloatingTextFieldDelegate {
    
    var isValid: Bool { get set }
    
    // MARK: - Using for seetting placeholder text in FloatingTextFieldPlaceholder
    func setPlaceholder(text: String)
    // MARK: - Using for adding button to the right side of input view
    func setRightAction(button: UIButton?)
    // MARK: - Hint action, need to set button that fully is ready for needed action(with target, selector, own size e.t.c)
    func setLeft(view: UIView)
    func setHintAction(button: UIButton?)
    // MARK: - Set needed colors and fonts
    func setRegular(font: UIFont?, color: UIColor?)
    func setValid(color: UIColor?)
    func setError(font: UIFont?, color: UIColor?)
    func setHint(font: UIFont?, color: UIColor?)
    func getText() -> String?
    func getInternalTextField() -> UITextField
    // MARK: - If field is empty
    func showRegularState()
    // MARK: - If data is valid
    func showValidState()
    // MARK: - If data isn't correct
    func showErrorState(with msg: String?, style: FloatingTextField.ErrorState?)
}

protocol FloatingTextFieldStyle {
    var leftView: UIView? { get set }
    var rightView: UIView? { get set }
    var placeholderText: String? { get set }
    var additionalTextFieldPlaceholder: String? { get set }
    var hintText: String? { get set }
    var hintButton: UIButton? { get set }
    var errorText: String? { get set }
    
    var regularTextFont: UIFont? { get set }
    var errorTextFont: UIFont? { get set }
    var hintTextFont: UIFont? { get set }
    
    var regularTextColor: UIColor? { get set }
    var errorTextColor: UIColor? { get set }
    var validTextColor: UIColor? { get set }
    var hintTextColor: UIColor? { get set }
    
    var separatorDefaultColor: UIColor? { get set }
    var errorState: FloatingTextField.ErrorState { get set }
    var leftInset: CGFloat? { get set }
    var rightInset: CGFloat? { get set }
}

class FloatingTextFieldDefaultStyle: FloatingTextFieldStyle {
    
    var regularTextFont: UIFont?
    var hintTextFont: UIFont?
    var errorTextFont: UIFont?
    
    var regularTextColor: UIColor? = .black
    var validTextColor: UIColor? = .black
    var errorTextColor: UIColor? =  .red
    var hintTextColor: UIColor? = AppColors.primaryLine
    var separatorDefaultColor: UIColor? = AppColors.primaryLine
    
    var leftView: UIView? = nil
    var rightView: UIView? = nil
    var hintButton: UIButton? = nil
    
    var placeholderText: String? = "Test this feature!"
    // Additional info for example "mm/yy"
    var additionalTextFieldPlaceholder: String?
    var hintText: String? = "Write something!"
    var errorText: String? = "Error :D"
    
    var errorState: FloatingTextField.ErrorState = .withBottomNotification
    var leftInset: CGFloat? = 16.0
    var rightInset: CGFloat? = 16.0
}

class FloatingTextField: UIView {
    
    enum ErrorState {
        case general
        case withBottomNotification
    }
    
    enum State {
        case idle
        case float
    }
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var elementsStackView: UIStackView!
    @IBOutlet private weak var leftCustomizedStackView: UIStackView!
    @IBOutlet private weak var rightCustomizedStackView: UIStackView!
    @IBOutlet private weak var textField: CustomTextField!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet weak var errorLabelPlaceholder: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var floatPropertyAnimator: UIViewPropertyAnimator?
    var idlePropertyAnimator: UIViewPropertyAnimator?
    
    private var workStack: [DispatchWorkItem] = []
    fileprivate var view: UIView!
    private var state: State = .idle
    
    // MARK: - Animation elements
    private var placeholderView: FloatingTextFieldPlaceholder?
    
    // MARK: - Style Config
    var config: FloatingTextFieldDefaultStyle = FloatingTextFieldDefaultStyle() {
        didSet {
            prepare()
        }
    }
    
    var isValid: Bool = true {
        didSet {
            if isValid {
                showValidState()
            } else {
                showErrorState()
            }
        }
    }
    
    // MARK: - Initializators
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
        prepare()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupXib()
        prepare()
    }
    
    private func prepare() {
        textField.subviews.forEach { (view) in
            if view is FloatingTextFieldPlaceholder {
                view.removeFromSuperview()
            }
        }
      
        errorLabelPlaceholder.isHidden = true
        textField.placeholder = ""
        separatorView.backgroundColor = config.separatorDefaultColor
        leftCustomizedStackView.isHidden = true
        if config.leftView == nil {
            textField.leftView = nil
        } else {
            textField.leftView = config.leftView
            changeToFloat(animated: false)
            changeToIdle(animated: false)
        }
        
        if config.rightView == nil { rightCustomizedStackView.isHidden = true } else {
            rightCustomizedStackView.isHidden = false
            rightCustomizedStackView.addArrangedSubview(config.rightView!)
        }
        errorLabel.text = config.errorText
        errorLabel.textColor = config.errorTextColor
        
        placeholderView = FloatingTextFieldPlaceholder()
        placeholderView?.frame = CGRect.init(x: textField.frame.minX, y: textField.frame.minY, width:
            
        textField.frame.width, height: textField.frame.height)
        textField.addSubview(placeholderView!)
        
        textField.font = config.regularTextFont
        textField.textColor = config.regularTextColor
        
        errorLabel.textColor = config.errorTextColor
        config.errorTextFont = AppFonts.monteserat18
        errorLabel.font = AppFonts.monteserat12
        
        placeholderView?.makeInsetFor(view: textField.leftView)
        placeholderView?.placeholderLabel.font = config.regularTextFont
        placeholderView?.placeholderLabel.text = config.placeholderText
        placeholderView?.placeholderLabel.textColor = config.hintTextColor
        
        if let unwrappedHint = config.hintButton {
            setHintAction(button: unwrappedHint)
        }
        
        leadingConstraint.constant = config.leftInset ?? 0.0
        trailingConstraint.constant = config.rightInset ?? 0.0
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(focus)))
        textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        setRegular()
    }
    
    // MARK: - make active
    
    func activate(force: Bool = false) {
        if (floatPropertyAnimator?.isRunning ?? false || idlePropertyAnimator?.isRunning ?? false) && !force { return }
        _ = textField.becomeFirstResponder()
    }
    
    func deactivate() {
        if !(floatPropertyAnimator?.isRunning ?? false) || !(idlePropertyAnimator?.isRunning ?? false) { return }
        textField.resignFirstResponder()
    }
    
    // MARK: - Animations
    @objc private func focus() {
        _ = textField.becomeFirstResponder()
    }
    
    private func forceEditing() {
        if let text = textField.text, text.isEmpty {
            changeToIdle(animated: false)
        } else {
            changeToFloat(animated: false)
        }
    }
    
    @objc private func editingDidEnd() {
        if let text = textField.text, text.isEmpty {
            changeToIdle(animated: true)
        } else {
            changeToFloat(animated: true)
        }
    }
    
    @objc private func editingDidBegin() {
        changeToFloat(animated: true)
    }
    
    private func changeToFloat(animated: Bool) {
        var scale: CGFloat = 0.875
        if let regularPointSize = config.regularTextFont?.pointSize, let hintPintSize =  config.hintTextFont?.pointSize {
            scale = hintPintSize/regularPointSize
        }
        
        if state == .float { return }
        cancelDelayedTasks()
        updateAnchorPoint()
        if floatPropertyAnimator?.isInterruptible ?? false {
            floatPropertyAnimator?.stopAnimation(true)
        }
        textField.placeholder = ""
        floatPropertyAnimator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [], animations: {
            self.placeholderView?.makeInsetFor(view: nil)
            self.placeholderView?.transform = CGAffineTransform.init(scaleX: scale, y: scale).translatedBy(x: 0, y: -24)
            self.placeholderView?.actionPlaceholderStackView.alpha = 1.0
            self.placeholderView?.clipsToBounds = true
            self.layoutIfNeeded()
        }) { (position) in
            if self.state != .idle {
                if self.config.additionalTextFieldPlaceholder != nil  {
                    self.textField.placeholder = self.config.additionalTextFieldPlaceholder
                } else {
                    self.textField.placeholder = ""
                }
            }
        }
        floatPropertyAnimator?.startAnimation()
        if !animated {
            self.state = .float
        } else {
            runDelayed(task: {
                 self.state = .float
            }, time: 0.0)
        }
    }
    
    private func changeToIdle(animated: Bool) {
        textField.placeholder = ""
        if state == .idle { return }
        cancelDelayedTasks()
        updateAnchorPoint()
        if idlePropertyAnimator?.isInterruptible ?? false {
            idlePropertyAnimator?.stopAnimation(true)
        }
        idlePropertyAnimator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [], animations: {
            self.textField.placeholder = ""
            self.placeholderView?.makeInsetFor(view: self.textField.leftView)
            self.placeholderView?.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
            self.placeholderView?.actionPlaceholderStackView.alpha = 0.0
            self.layoutIfNeeded()
        })
        idlePropertyAnimator?.startAnimation()
        textField.placeholder = ""
        if !animated {
            self.state = .idle
        } else {
            runDelayed(task: {
                self.state = .idle
            }, time: 0.0)
        }
    }
    
    func runDelayed(task: @escaping (() -> Void), time: Double) {
        let work = DispatchWorkItem(block: {
            task()
            self.cancelDelayedTask()
        })
        
        workStack.append(work)
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: work)
    }
    
    func cancelDelayedTasks() {
        workStack.forEach { workItem in
            workItem.cancel()
        }
        workStack.removeAll()
    }
    
    func cancelDelayedTask() {
        workStack.first?.cancel()
        if !workStack.isEmpty {
            workStack.removeFirst()
        }
    }
    
    private func updateAnchorPoint() {
        placeholderView?.layer.position = CGPoint.init(x: 0, y: 0)
        placeholderView?.layer.anchorPoint = CGPoint.init(x: 0, y: 0)
    }
}

// MARK: - Public methods
extension FloatingTextField: FloatingTextFieldDelegate {
    
    func updateStateIfNeeded() {
        if state == .idle {
            changeToIdle(animated: true)
        }
    }
    
    func setPlaceholder(text: String) {
        config.placeholderText = text
        config.hintText = text
        placeholderView?.placeholderLabel.text = config.placeholderText
    }
    
    func setRightAction(button: UIButton?) {
        if let unwrapped = button {
            config.rightView = unwrapped
            prepare()
        }
    }
    
    func setLeft(view: UIView) {
        config.leftView = view
        prepare()
    }
    
    func setHintAction(button: UIButton?) {
        if let unwrapped = button {
            placeholderView?.setAction(button: unwrapped)
        }
    }
    
    func setHint(font: UIFont?, color: UIColor?) {
        if let unwrappedFont = font {
            config.hintTextFont = unwrappedFont
        }
        if let unwrappedColor = color {
            config.hintTextColor = unwrappedColor
        }
    }
    
    func setRegular(font: UIFont? = nil, color: UIColor? = nil) {
        if let unwrappedFont = font {
            config.regularTextFont = unwrappedFont
        }
        if let unwrappedColor = color {
            config.regularTextColor = unwrappedColor
        }
    }
    
    func setError(font: UIFont? = nil, color: UIColor? = nil) {
        if let unwrappedFont = font {
            config.errorTextFont = unwrappedFont
        }
        if let unwrappedColor = color {
            config.errorTextColor = unwrappedColor
        }
    }
    
    func setValid(color: UIColor?) {
        config.validTextColor = color
    }
    
    func showRegularState() {
        placeholderView?.placeholderLabel.font = config.regularTextFont // Styles.fontStyle(name: Styles.form01FontFamily, size: Styles.form01FontSize, weight: Styles.form01FontWeight)
        placeholderView?.placeholderLabel.textColor = config.hintTextColor
        placeholderView?.placeholderLabel.textColor =  config.regularTextColor//Styles.textGrey02
        separatorView.backgroundColor = config.separatorDefaultColor
    }
    
    func showValidState() {
        errorLabel.isHidden = true
        errorLabelPlaceholder.isHidden = true
        if textField.text?.isEmpty ?? true { setRegular(); return }
        if let unwrapped = config.validTextColor {
            placeholderView?.placeholderLabel.textColor = unwrapped
            placeholderView?.placeholderLabel.text = config.hintText
            textField.textColor = config.regularTextColor
            separatorView.backgroundColor = config.regularTextColor
        } else {
            setRegular()
        }
    }
    
    func showErrorState(with msg: String? = nil, style: ErrorState? = nil) {
        if let unwrappedErrorMessage = msg {
            config.errorText = unwrappedErrorMessage
        }
        if let unwrapedStyle = style {
            config.errorState = unwrapedStyle
        }
        
        if textField.text?.isEmpty ?? true { setRegular(); return }
        
        switch config.errorState {
        case .general:
            errorLabel.isHidden = true
            if state == .float {
                placeholderView?.placeholderLabel.textColor =  config.errorTextColor
            } else {
                placeholderView?.placeholderLabel.textColor = config.hintTextColor
            }
            
            placeholderView?.placeholderLabel.text = config.placeholderText
            if config.errorText != nil {
              //  placeholderView?.placeholderLabel.text = config.errorText
            }
        case .withBottomNotification:
            errorLabel.font = config.errorTextFont
            errorLabel.isHidden = false
            errorLabelPlaceholder.isHidden = false
            if state == .float {
                placeholderView?.placeholderLabel.textColor = config.errorTextColor
            } else {
                placeholderView?.placeholderLabel.textColor = config.hintTextColor
            }
            errorLabel.text = config.errorText
            errorLabel.font = config.errorTextFont
        }
        separatorView.backgroundColor = config.errorTextColor
        layoutIfNeeded()
    }
    
    func getText() -> String? {
        return textField.text
    }
    
    func getInternalTextField() -> UITextField {
        return textField
    }
}

extension FloatingTextField {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if state == .float {
            let button = (placeholderView?.actionPlaceholderStackView.subviews.first) as? UIButton
            if let translatedPoint = button?.convert(point, from: self) {
                if button?.bounds.contains(translatedPoint) ?? false {
                    return button?.hitTest(translatedPoint, with: event)
                }
            }
        }
        return super.hitTest(point, with: event)
    }
    
    func setupXib() {
        view = loadNib()
        view.frame = bounds
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view as UIView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view as UIView]))
    }
}
