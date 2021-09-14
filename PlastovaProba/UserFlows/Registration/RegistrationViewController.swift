//
//  RegistrationViewController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 27.09.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit
import RLBAlertsPickers
import Firebase
import FirebaseAuth
import SVProgressHUD

class RegistrationViewController: UIViewController {
    
    enum RegistrationType: String {
        case scoutMaster = "scout_master"
        case scout = "scout"
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailTextField: FloatingTextField!
    @IBOutlet weak var passwordTextField: FloatingTextField!
    @IBOutlet weak var repeatPasswordTextField: FloatingTextField!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var keyboardHandler: KeyboardHandler?
    var registrationType: RegistrationType = .scoutMaster
    
    var dataSourceModel = RegistrationDataSourceModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackButton()
        setupKeyboardHandler()
        setupUI()
    }
    
    private func setupKeyboardHandler() {
        keyboardHandler = KeyboardHandler(controller: self, bottomConstraint: bottomConstraint)
    }
    
    private func setupUI() {
        titleLabel.font = AppFonts.monteseratBold24
        subtitleLabel.font = AppFonts.monteserat12
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppColors.green], for: UIControl.State.selected)
        
        registrationButton.isUserInteractionEnabled = false
        registrationButton.alpha = 0.3
        
        setupLocalization()
    }
    
    private func setupLocalization() {
        titleLabel.text = "registration_step_1_title".localized
        subtitleLabel.text =  "registration_step_1_subtitle".localized
        emailTextField.setPlaceholder(text: "registration_step_1_email".localized)
        passwordTextField.setPlaceholder(text: "registration_step_1_password".localized)
    
        emailTextField.getInternalTextField().addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        let unsecurePasswordButton = UIButton(frame: .zero)
        unsecurePasswordButton.addTarget(self, action: #selector(RegistrationViewController.showPassword(sender:)), for: .touchUpInside)
        unsecurePasswordButton.setImage(UIImage(named: "eye"), for: .normal)
        unsecurePasswordButton.activate(heightAnchor: 20.0)
        unsecurePasswordButton.activate(widthAnchor: 30.0)
        passwordTextField.getInternalTextField().isSecureTextEntry = true
        passwordTextField.getInternalTextField().addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: .editingChanged)

        passwordTextField.setRightAction(button: unsecurePasswordButton)
        passwordTextField.config = passwordTextField.config
        
        repeatPasswordTextField.setPlaceholder(text: "registration_step_1_repeat_password".localized)
        let unsecureRepeatedPasswordButton = UIButton(frame: .zero)
        unsecureRepeatedPasswordButton.addTarget(self, action: #selector(RegistrationViewController.showRepeatedPassword(sender:)), for: .touchUpInside)
        unsecureRepeatedPasswordButton.setImage(UIImage(named: "eye"), for: .normal)
        unsecureRepeatedPasswordButton.activate(heightAnchor: 20.0)
        unsecureRepeatedPasswordButton.activate(widthAnchor: 30.0)
        repeatPasswordTextField.setRightAction(button: unsecureRepeatedPasswordButton)
        repeatPasswordTextField.getInternalTextField().addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: .editingChanged)
        registrationButton.backgroundColor = AppColors.green
        registrationButton.layer.cornerRadius = 8.0
        registrationButton.setTitleColor(AppColors.white, for: .normal)
        registrationButton.setTitle("onboarding_next".localized, for: .normal)
    }
    
    @objc func showPassword(sender: UIButton) {
        passwordTextField.getInternalTextField().isSecureTextEntry = !(passwordTextField.getInternalTextField().isSecureTextEntry)
    }
    
    @objc func showRepeatedPassword(sender: UIButton) {
        passwordTextField.getInternalTextField().isSecureTextEntry = !(passwordTextField.getInternalTextField().isSecureTextEntry)
    }
    
    @IBAction func changeRegistrationType(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            registrationType = .scoutMaster
        } else {
           registrationType = .scout
        }
    }
    
    @IBAction func register(_ sender: Any) {
        guard let email = emailTextField.getText(), !email.isEmpty else {
            return
        }
        
        guard let password = passwordTextField.getText(), !password.isEmpty else {
            return
        }
        
        guard let confirmPassword = repeatPasswordTextField.getText(), !confirmPassword.isEmpty else {
            return
        }
        
        guard password == confirmPassword else {
            showError(message: "Паролі мають співпадати")
            return
        }
        
        register(email: email, password: password)
    }
    
    private func register(email: String, password: String) {
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            DispatchQueue.main.async {
                if let unwrappedResult = result {
                    unwrappedResult.user.sendEmailVerification { (error) in
                        unwrappedResult.user.getIDToken { (token, error) in
                            guard let unwrappedToken = token else { return }
                            Token.accessToken = unwrappedToken
                            self.dataSourceModel.register(email: email, type: self.registrationType) { success in
                                if success {
                                    if !unwrappedResult.user.isEmailVerified {
                                        DispatchQueue.main.async {
                                            self.showActivationController()
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    self.showError(message: "Користувач з таким емейлом уже зареєстрований.")
                }
                
                SVProgressHUD.dismiss()
            }
        }
    }
    
    private func showActivationController() {
        let storyboard = UIStoryboard(name: "UserDescription", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AccountActivationViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(style: .alert, message: message)
        alert.addAction(UIAlertAction.init(title: "Добре", style: .cancel, handler: nil))
        alert.show()
    }
    
    private func showSuccessMessage(message: String) {
        let alert = UIAlertController(style: .alert, message: message)
        alert.addAction(UIAlertAction.init(title: "Добре", style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.show()
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let email = emailTextField.getText() ?? ""
        let password = passwordTextField.getText() ?? ""
        let confirmPassword = repeatPasswordTextField.getText() ?? ""
        
        let isEmailValid = VaildatorFactory.validatorFor(type: .email).validated(email)
        let isPasswordValid = VaildatorFactory.validatorFor(type: .password).validated(password)
        let isConfirmPasswordValid = VaildatorFactory.validatorFor(type: .password).validated(confirmPassword)
        
        if isEmailValid && isPasswordValid && isConfirmPasswordValid {
            registrationButton.alpha = 1.0
            registrationButton.isUserInteractionEnabled = true
        } else {
            registrationButton.alpha = 0.3
            registrationButton.isUserInteractionEnabled = false
        }
        
        if !isEmailValid {
            emailTextField.showErrorState(with: "Некоректний емейл", style: .withBottomNotification)
        }
        emailTextField.isValid = isEmailValid
        
        if !isPasswordValid {
            passwordTextField.showErrorState(with: "Мінімум 6 символів", style: .withBottomNotification)
        }
        passwordTextField.isValid = isPasswordValid
        
        if !isConfirmPasswordValid {
            repeatPasswordTextField.showErrorState(with: "Мінімум 6 символів", style: .withBottomNotification)
        }
        repeatPasswordTextField.isValid = isConfirmPasswordValid
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
