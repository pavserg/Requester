//
//  KeyboardHandler.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 23.10.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

class KeyboardHandler {
    
    private weak var bottomConstraint: NSLayoutConstraint?
    private weak var controller: UIViewController?
    private var removeSafeArea: Bool = false
    
    var keyboardWillHideHandler: (() -> Void)?
    var keyboardWillShowHandler: ((_ keyboardRect: CGRect) -> Void)?
    
    init(controller: UIViewController?, bottomConstraint: NSLayoutConstraint, removeSafeArea: Bool = false) {
        self.controller = controller
        self.bottomConstraint = bottomConstraint
        self.removeSafeArea = removeSafeArea
        setupKeyboardHandler()
    }
    
    func setupKeyboardHandler() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if removeSafeArea {
                if #available(iOS 11.0, *) {
                    let window = UIApplication.shared.keyWindow
                    let bottomPadding: CGFloat = window?.safeAreaInsets.bottom ?? 0
                    bottomConstraint?.constant = keyboardSize.height - bottomPadding
                } else {
                    bottomConstraint?.constant = keyboardSize.height
                }
            } else {
                bottomConstraint?.constant = keyboardSize.height
            }
            keyboardWillShowHandler?(keyboardSize)
            UIView.animate(withDuration: 0.3) {
                self.controller?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        bottomConstraint?.constant = 0.0
        keyboardWillHideHandler?()
        UIView.animate(withDuration: 0.3) {
            self.controller?.view.layoutIfNeeded()
        }
    }
}
