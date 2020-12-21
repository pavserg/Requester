//
//  AddNewScoutController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 04.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit
import RLBAlertsPickers

class AddNewScoutController: UIViewController {
    
    @IBOutlet weak var titleHeaderLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailTextField: FloatingTextField!
    @IBOutlet weak var rangTextField: FloatingTextField!
    @IBOutlet weak var addButton: UIButton!
    
    private var registrationDataSourceModel = RegistrationDataSourceModel()
    
    private var rangString: String?
    
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
      
        //emailTextField.getInternalTextField().addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: .editingChanged)
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
       // addButton.isUserInteractionEnabled = false
       // addButton.alpha = 0.3
    }
    
    @IBAction func showRangPicker(_ sender: Any) {
        showRangPickerView()
    }
    
    private func showRangPickerView() {
        view.endEditing(true)
        let alert = UIAlertController(style: .actionSheet, title: "Вибери ступінь", message: "")
        let frameSizes: [CGFloat] = (150...400).map { CGFloat($0) }
        let pickerViewValues: [[String]] = [["Прихильник/ця",  "Учасник/ця", "Розвідувач/ка"]]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
           
            switch index.row {
            case 0:
                self.rangString =  "sympathizer"
            case 1:
                self.rangString = "first_challenge"
            case 2:
                self.rangString = "second_challenge"
            default:
                self.rangString =  "sympathizer"
                
            }
       
            DispatchQueue.main.async {
                self.rangTextField.getInternalTextField().text = values.first?[index.row]
                self.rangTextField.forceEditing()
            }
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    @IBAction func addNewScout(_ sender: Any) {
        
        guard let unwrappedRang = rangString, let email = emailTextField.getText()  else {
            CommonAlert.showError(title: "Дані не можуть бути порожніми!")
            return
        }
        
        registrationDataSourceModel.addScout(email: email, rank: unwrappedRang) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                CommonAlert.showError(title: "Щось пішло не так :(")
            }
        }
    }
}
