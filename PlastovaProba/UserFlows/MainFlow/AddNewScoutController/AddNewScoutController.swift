//
//  AddNewScoutController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 04.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

class AddNewScoutController: UIViewController {
    
    @IBOutlet weak var titleHeaderLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailTextField: FloatingTextField!
    @IBOutlet weak var rangTextField: FloatingTextField!
    @IBOutlet weak var addButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButton()
        setupUI()
    }
    
    private func setupUI() {
        titleHeaderLabel.font = AppFonts.monteseratBold24
        titleHeaderLabel.text = "add_scout".localized
        subtitleLabel.font = AppFonts.monteserat12
        subtitleLabel.text = "add_scout_description".localized
      
        emailTextField.getInternalTextField().addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.setPlaceholder(text: "login_email".localized)
        emailTextField.setRegular(font: AppFonts.monteserat18, color: AppColors.black)
        emailTextField.config = emailTextField.config
        
        rangTextField.setRegular(font: AppFonts.monteserat18, color: AppColors.black)
        rangTextField.setPlaceholder(text: "Ступінь у пласті".localized)
        rangTextField.config = rangTextField.config

        addButton.backgroundColor = AppColors.green
        addButton.layer.cornerRadius = 8.0
        addButton.setTitleColor(AppColors.white, for: .normal)
        addButton.setTitle("Додати".localized, for: .normal)
        addButton.isUserInteractionEnabled = false
        addButton.alpha = 0.3
    }
    
    @IBAction func addNewScout(_ sender: Any) {
        
    }
}
