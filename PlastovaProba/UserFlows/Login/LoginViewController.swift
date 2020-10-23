//
//  LoginViewController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 07.07.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit
import Firebase
import RLBAlertsPickers
import SVProgressHUD

class LoginViewController: UIViewController {
    
    enum LoginType {
        case scoutMaster
        case scout
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailTextField: FloatingTextField!
    @IBOutlet weak var passwordTextField: FloatingTextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cantLoginButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var keyboardHandler: KeyboardHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButton()
        setupKeyboarddHandler()
        setupUI()
    }
    
    private func setupKeyboarddHandler() {
        keyboardHandler = KeyboardHandler(controller: self, bottomConstraint: bottomConstraint)
    }
    
    func setupUI() {
        titleLabel.text = "login_hello".localized
        subtitleLabel.text = "login_scout_master_login_and_see_your_group".localized
        
        emailTextField.setPlaceholder(text: "login_email".localized)
  
        emailTextField.getInternalTextField().addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: .editingChanged)
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
        passwordTextField.getInternalTextField().delegate = self
        passwordTextField.getInternalTextField().addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.setRightAction(button: unsecurePasswordButton)
        passwordTextField.config = passwordTextField.config
        continueButton.backgroundColor = AppColors.green
        continueButton.layer.cornerRadius = 8.0
        continueButton.setTitleColor(AppColors.white, for: .normal)
        continueButton.setTitle("login_login".localized, for: .normal)
        cantLoginButton.halfTextColorChange(fullText:   "login_cant_login".localized + " " + "login_change_password".localized, changeText: "login_change_password".localized)
        
        setupRegistrationButton()
        
        continueButton.isUserInteractionEnabled = false
        continueButton.alpha = 0.3
    }
    
    func setupRegistrationButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "login_registartion".localized, style: .plain, target: self, action: #selector(showRegistrationController))
        
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: AppFonts.monteserat12 as Any,
                                                                   NSAttributedString.Key.foregroundColor: AppColors.green as Any],
                                                                  for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: AppFonts.monteserat12 as Any,
                                                                   NSAttributedString.Key.foregroundColor: AppColors.green as Any],
                                                                  for: .selected)
    }
    
    // MARK: - Actions
    @IBAction func login(_ sender: Any) {
        
        guard let email = emailTextField.getText(), let password = passwordTextField.getText() else { return }
        
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            DispatchQueue.main.async {
                if let unwrappedResult = result {
                    if !unwrappedResult.user.isEmailVerified {
                        self.showError(message: "Емейл не підтверджено. Перевірте пошту.")
                    }
                    unwrappedResult.user.getIDToken { (token, error) in
                        print(token)
                    }
                } else {
                    self.showError(message: "Такого користувача немає.")
                }
                
                SVProgressHUD.dismiss()
            }
        }
    }
    
    
    @objc func showPassword(sender: UIButton) {
        passwordTextField.getInternalTextField().isSecureTextEntry = !(passwordTextField.getInternalTextField().isSecureTextEntry)
    }
    
    @objc func showRegistrationController() {
        let storyboard = UIStoryboard.init(name: "Registration", bundle: nil)
        let registrationController = storyboard.instantiateViewController(withIdentifier: "RegistrationViewController")
        navigationController?.pushViewController(registrationController, animated: true)
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(style: .alert, message: message)
        alert.addAction(UIAlertAction.init(title: "Добре", style: .cancel, handler: nil))
        alert.show()
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let email = emailTextField.getText() ?? ""
        let password = passwordTextField.getText() ?? ""
        
        let isEmailValid = VaildatorFactory.validatorFor(type: .email).validated(email)
        let isPasswordValid = VaildatorFactory.validatorFor(type: .password).validated(password)
        
        if isEmailValid && isPasswordValid {
            continueButton.alpha = 1.0
            continueButton.isUserInteractionEnabled = true
        } else {
            continueButton.alpha = 0.3
            continueButton.isUserInteractionEnabled = false
        }
        
        if !isEmailValid {
            emailTextField.showErrorState(with: "Некоректний емейл", style: .withBottomNotification)
        }
        emailTextField.isValid = isEmailValid
        
        if !isPasswordValid {
            passwordTextField.showErrorState(with: "Некоректний пароль", style: .withBottomNotification)
        }
        passwordTextField.isValid = isPasswordValid
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
