//
//  AccountActivationViewController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 18.11.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountActivationViewController: UIViewController {
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocalization()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func setupLocalization() {
        warningLabel.text = "activate_controller_warning".localized
    }
    
    private func setupUI() {
     
        warningLabel.font = AppFonts.monteserat18
        continueButton.backgroundColor = AppColors.green
        continueButton.layer.cornerRadius = 8.0
        continueButton.setTitleColor(AppColors.white, for: .normal)
        continueButton.setTitle("onboarding_next".localized, for: .normal)
        
        cancelButton.setTitleColor(AppColors.green, for: .normal)
        cancelButton.setTitle("activate_controller_return_to_launch_screen".localized, for: .normal)
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(style: .alert, message: message)
        alert.addAction(UIAlertAction.init(title: "Добре", style: .cancel, handler: nil))
        alert.show()
    }
    
    @IBAction func `continue`(_ sender: Any) {
        if !(Auth.auth().currentUser?.isEmailVerified ?? false) {
            showError(message: "activate_controller_error".localized)
        } else {
            let storyboard = UIStoryboard(name: "UserDescription", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "UserDescriptionController")
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
