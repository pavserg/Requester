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
    
    enum Sex: Int {
        case female = 0
        case male = 1
        case none
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstNameLabel: FloatingTextField!
    @IBOutlet weak var lastNameLabel: FloatingTextField!
    @IBOutlet weak var sexLabel: FloatingTextField!
    @IBOutlet weak var birthDateLabel: FloatingTextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var keyboardHandler: KeyboardHandler?
    
    var sex: Sex = .none
    var birthDate: Date?
    
    private var registrationDataSourceModel = RegistrationDataSourceModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableButton()
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
        
        firstNameLabel.getInternalTextField().addTarget(self, action: #selector(UserDescriptionController.textFieldDidChange(_:)), for: .editingChanged)
        
        lastNameLabel.getInternalTextField().addTarget(self, action: #selector(UserDescriptionController.textFieldDidChange(_:)), for: .editingChanged)
        
        sexLabel.getInternalTextField().addTarget(self, action: #selector(UserDescriptionController.textFieldDidChange(_:)), for: .editingChanged)
        
        birthDateLabel.getInternalTextField().addTarget(self, action: #selector(UserDescriptionController.textFieldDidChange(_:)), for: .editingChanged)
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
            self.sex = Sex(rawValue: index.row) ?? .none
            DispatchQueue.main.async {
                self.sexLabel.getInternalTextField().text = values.first?[index.row]
                self.sexLabel.forceEditing()
                self.textFieldDidChange(self.sexLabel.getInternalTextField())
            }
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    private func showBirthdayPickerView() {
        view.endEditing(true)
        let alert = UIAlertController(style: .alert, title: "Вкажи свою дату народження", message: "")
        let currentDate = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = -100
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
    
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: minDate, maximumDate: currentDate) { (date) in
            self.birthDate = date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let stringDate = dateFormatter.string(from: date)
            self.birthDateLabel.getInternalTextField().text = stringDate
            self.birthDateLabel.forceEditing()
            self.textFieldDidChange(self.birthDateLabel.getInternalTextField())
        }
        
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    @IBAction func `continue`(_ sender: Any) {
        guard let firstName = firstNameLabel.getText(), !firstName.isEmpty else {
            firstNameLabel.showErrorState(with: "Додайте ім'я", style: .withBottomNotification)
            return
        }
              
        guard let lastName = lastNameLabel.getText(), !lastName.isEmpty else {
            lastNameLabel.showErrorState(with: "Додайте прізвище", style: .withBottomNotification)
            return
        }
        
        guard sex != .none else {
            sexLabel.showErrorState(with: "Додайте стать", style: .withBottomNotification)
            return
        }
        
        guard let birthDate = birthDate else {
            birthDateLabel.showErrorState(with: "Вкажіть дату народження", style: .withBottomNotification)
            return
        }
        
        let timestamp = birthDate.timeIntervalSince1970
        registrationDataSourceModel.updateUserInfo(firstName: firstName, lastName: lastName, sex: sex == .male ? "male" : "female", birthdate: Int64(timestamp)) { scout, error  in
            if error == nil {
                Scout.currentUser = scout
                if scout?.role == "scout_master" {
                    DispatchQueue.main.async {
                        self.loadCreateBandController(user: scout)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.loadHomeController(user: scout)
                    }
                }
            } else {
                
            }
        }
    }
    
    private func loadHomeController(user: Scout?) {
        let storyboard = UIStoryboard(name: "MainFlow", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
        UIApplication.shared.delegate?.window??.rootViewController = controller
    }
    
    private func loadCreateBandController(user: Scout?) {
        let storyboard = UIStoryboard(name: "UserDescription", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "AddBandViewController") as? AddBandViewController {
            controller.scout = user
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension UserDescriptionController: UITextFieldDelegate {
    
    func disableButton() {
        nextButton.alpha = 0.3
        nextButton.isUserInteractionEnabled = false
    }
    
    func enableButton() {
        nextButton.alpha = 1.0
        nextButton.isUserInteractionEnabled = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        guard let firstName = firstNameLabel.getText(), !firstName.isEmpty else {
            disableButton()
            return
        }
              
        guard let lastName = lastNameLabel.getText(), !lastName.isEmpty else {
            disableButton()
            return
        }
        
        guard sex != .none else {
            disableButton()
            return
        }
        
        guard birthDate != nil else {
            disableButton()
            return
        }
        
        enableButton()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
