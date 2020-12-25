//
//  AddBandViewController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 18.11.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddBandViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var bandTitleTextField: FloatingTextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var registrationDataSourceModel = RegistrationDataSourceModel()
    
    var keyboardHandler: KeyboardHandler?
    
    var scout: Scout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocalization()
        setupBackButton()
        setupUI()
    }
    
    override func back() {
        super.back()
        if navigationController?.viewControllers.count == 1 {
            CommonAlert.showError(title: "Перш ніж продовжити ти маєш створити гурток.")
        }
    }
    
    private func setupLocalization() {
        titleLabel.text = "add_band_tell_about_your_band".localized
        subtitleLabel.text = "add_band_additional_bands_info".localized
        bandTitleTextField.setPlaceholder(text:  "add_band_band_title_placeholder".localized)
    }
    
    private func setupUI() {
        keyboardHandler = KeyboardHandler(controller: self, bottomConstraint: bottomConstraint)
        titleLabel.font = AppFonts.monteseratBold24
        subtitleLabel.font = AppFonts.monteserat12
        continueButton.backgroundColor = AppColors.green
        continueButton.layer.cornerRadius = 8.0
        continueButton.setTitleColor(AppColors.white, for: .normal)
        continueButton.setTitle("onboarding_next".localized, for: .normal)
    }
    
    @IBAction func `continue`(_ sender: Any) {
        SVProgressHUD.show()
        registrationDataSourceModel.createBand(bandName: bandTitleTextField.getText() ?? "Pinterest") { (success) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                if success {
                    self.loadHomeController(user: self.scout)
                } else {
                    CommonAlert.showError(title: "Щось пішло не так.")
                }
            }
        }
    }
    
    private func loadHomeController(user: Scout?) {
        let storyboard = UIStoryboard(name: "MainFlow", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
        UIApplication.shared.delegate?.window??.rootViewController = controller
    }
}
