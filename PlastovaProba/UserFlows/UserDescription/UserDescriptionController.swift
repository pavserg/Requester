//
//  UserDescriptionController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 04.11.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit
import RLBAlertsPickers

class UserDescriptionController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstNameLabel: FloatingTextField!
    @IBOutlet weak var lastNameLabel: FloatingTextField!
    @IBOutlet weak var sexLabel: FloatingTextField!
    @IBOutlet weak var birthDateLabel: FloatingTextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var keyboardHandler: KeyboardHandler?
    
    private var registrationDataSourceModel = RegistrationDataSourceModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocalization()
        setupBackButton()
        setupUI()
    }
    
    private func setupLocalization() {
        titleLabel.text = "user_description_tell_about_yourself".localized
        firstNameLabel.setPlaceholder(text: "user_description_firstname".localized)
        lastNameLabel.setPlaceholder(text: "user_description_lastname".localized)
        sexLabel.setPlaceholder(text: "user_description_sex".localized)
        birthDateLabel.setPlaceholder(text: "user_description_birthdate".localized)
    }
    
    private func setupUI() {
        keyboardHandler = KeyboardHandler(controller: self, bottomConstraint: bottomConstraint)
        titleLabel.font = AppFonts.monteseratBold24
        
        nextButton.backgroundColor = AppColors.green
        nextButton.layer.cornerRadius = 8.0
        nextButton.setTitleColor(AppColors.white, for: .normal)
        nextButton.setTitle("onboarding_next".localized, for: .normal)
    }
    
    @IBAction func showSex(_ sender: Any) {
        showSexPickerView()
    }
    
    @IBAction func showArea(_ sender: Any) {
        showBirthdayPickerView()
    }
    
    private func showSexPickerView() {
        view.endEditing(true)
        let alert = UIAlertController(style: .actionSheet, title: "Вибери свою стать", message: "")
        let frameSizes: [CGFloat] = (150...400).map { CGFloat($0) }
        let pickerViewValues: [[String]] = [["Жіноча",  "Чоловіча"]]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async {
                self.sexLabel.getInternalTextField().text = values.first?[index.row]
                self.sexLabel.forceEditing()
            }
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    private func showBirthdayPickerView() {
        view.endEditing(true)
        let alert = UIAlertController(style: .actionSheet, title: "Вкажи свою дату народження", message: "")
 
        let currentDate = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = -100
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
    
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: minDate, maximumDate: currentDate) { (date) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let stringDate = dateFormatter.string(from: date)
            self.birthDateLabel.getInternalTextField().text = stringDate
            self.birthDateLabel.forceEditing()

        }
        
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    @IBAction func `continue`(_ sender: Any) {
        guard let firstName = firstNameLabel.getText(), let lastName = lastNameLabel.getText(), let birthDate = birthDateLabel.getText(), let sex = sexLabel.getText() else { return }
        
        registrationDataSourceModel.updateUserInfo(firstName: firstName, lastName: lastName, sex: "male", birthdate: 90902309) { (success) in
            if success {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "UserDescription", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "AddBandViewController")
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
     
    }
}
