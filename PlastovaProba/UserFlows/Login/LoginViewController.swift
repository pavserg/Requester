//
//  LoginViewController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 07.07.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailTextField: FloatingTextField!
    @IBOutlet weak var passwordTextField: FloatingTextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cantLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        setupNavigationBar(right: nil)
        setupUI()
    }
    
    func setupUI() {
        titleLabel.text = "login_hello".localized
        subtitleLabel.text = "login_scout_master_login_and_see_your_group".localized
        
        emailTextField.setPlaceholder(text: "login_email".localized)
        emailTextField.setRegular(font: AppFonts.monteserat18, color: AppColors.black)
        emailTextField.config = emailTextField.config
        passwordTextField.setPlaceholder(text: "login_password".localized)
        passwordTextField.setRegular(font: AppFonts.monteserat18, color: AppColors.black)
        
        let unsecurePasswordButton = UIButton(frame: .zero)
        unsecurePasswordButton.addTarget(self, action: #selector(LoginViewController.showPassword(sender:)), for: .touchUpInside)
        unsecurePasswordButton.setImage(UIImage(named: "eye"), for: .normal)
        unsecurePasswordButton.activate(heightAnchor: 20.0)
        unsecurePasswordButton.activate(widthAnchor: 30.0)
        passwordTextField.getInternalTextField().isSecureTextEntry = true
        
        passwordTextField.setRightAction(button: unsecurePasswordButton)
        passwordTextField.config = passwordTextField.config
        continueButton.backgroundColor = AppColors.green
        continueButton.layer.cornerRadius = 8.0
        continueButton.setTitleColor(AppColors.white, for: .normal)
        continueButton.setTitle("login_login".localized, for: .normal)
        cantLoginButton.halfTextColorChange(fullText:   "login_cant_login".localized + " " + "login_change_password".localized, changeText: "login_change_password".localized)
    }
    
    @objc func showPassword(sender: UIButton) {
      passwordTextField.getInternalTextField().isSecureTextEntry = !(passwordTextField.getInternalTextField().isSecureTextEntry)
    }
}

