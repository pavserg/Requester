//
//  FloatingTextFieldPlaceholder.swift
//  FloatingTextFieldPlaceholder
//
//  Created by Pavlo Dumyak on 29.06.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

class FloatingTextFieldPlaceholder: UIView {
    
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var actionPlaceholderStackView: UIStackView!
    @IBOutlet weak var leadingInset: NSLayoutConstraint!
    
    fileprivate var view: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
      
    // MARK: - Initializators
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupXib()
    }
    
    func makeInsetFor(view: UIView?) {
        if let width = view?.bounds.width {
            leadingInset.constant = width
        } else {
            leadingInset.constant = 0.0
        }
        layoutIfNeeded()
    }
}

extension FloatingTextFieldPlaceholder {
    func setAction(button: UIButton) {
        actionPlaceholderStackView.removeAll()
        actionPlaceholderStackView.alpha = 0.0
        actionPlaceholderStackView.addArrangedSubview(button)
    }
}

private extension FloatingTextFieldPlaceholder {
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
