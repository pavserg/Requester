//
//  String+Helpers.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 30.06.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension UILabel {
    func halfTextColorChange(fullText: String, changeText: String ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.green, range: range)
        self.attributedText = attribute
    }
}

extension UIButton {
    func  halfTextColorChange(fullText: String, changeText: String ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let rangeOfMainPart = (strNumber).range(of: strNumber as String)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.black, range: rangeOfMainPart)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.green, range: range)
        self.setAttributedTitle(attribute, for: .normal)
    }
}

typealias Action = (image: String, closure: (() -> Void))

extension UIViewController {
    
    func setupBackButton() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        navigationItem.setHidesBackButton(true, animated: false)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -33, bottom: 0, right: 0)
        let back = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItem = back
        navigationItem.leftBarButtonItem?.title = ""
        navigationItem.rightBarButtonItem?.title = ""
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    @objc func right() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension UIView {

    enum ActivateTypes {
        case leading(CGFloat)
        case trailing(CGFloat)
        case bottom(CGFloat)
        case top(CGFloat)
        case centerX(CGFloat)
        case centerY(CGFloat)
        
        case topBottom(CGFloat)
        case bottomTop(CGFloat)
    }
    
    func activate(heightAnchor: CGFloat) {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: heightAnchor)
        ])
    }
    
    func activate(widthAnchor: CGFloat) {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: widthAnchor)
        ])
    }
    
    func activateFor(view: UIView, types: ActivateTypes...) {
        for type in types {
            switch type {
            case .top(let value):
                self.topAnchor.constraint(equalTo: view.topAnchor, constant: value).isActive = true
            case .bottom(let value):
                self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: value).isActive = true
            case .leading(let value):
                self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: value).isActive = true
            case .trailing(let value):
                self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: value).isActive = true
            case .centerX(let value):
                self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: value).isActive = true
            case .centerY(let value):
                self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: value).isActive = true
            case .bottomTop(let value):
                self.bottomAnchor.constraint(equalTo: view.topAnchor, constant: value).isActive = true
            case .topBottom(let value):
                self.topAnchor.constraint(equalTo: view.bottomAnchor, constant: value).isActive = true
            }
        }
    }
}


class CustomTextField: UITextField {
    
    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        if isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            insertText(text)
        }
        return success
    }
}



extension String {
    func changeFontForNumbers() -> NSMutableAttributedString {
        let bold = [NSAttributedString.Key.font: AppFonts.monteseratBold24]
        
        let myAttributedString = NSMutableAttributedString()
        for letter in self.unicodeScalars {
            let myLetter : NSAttributedString
            if CharacterSet.decimalDigits.contains(letter) {
                myLetter = NSAttributedString(string: "\(letter)", attributes: bold)
            } else {
                myLetter = NSAttributedString(string: "\(letter)")
            }
            myAttributedString.append(myLetter)
        }
        
        return myAttributedString
    }
}

