//
//  AddBandViewController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 18.11.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

class AddBandViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var bandTitleTextField: FloatingTextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var registrationDataSourceModel = RegistrationDataSourceModel()
    
    var keyboardHandler: KeyboardHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocalization()
        setupBackButton()
        setupUI()
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
        registrationDataSourceModel.createBand(bandName: bandTitleTextField.getText() ?? "Pinterest") { (success) in
            
        }
    }
}
