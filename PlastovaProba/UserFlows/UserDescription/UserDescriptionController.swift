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
    @IBOutlet weak var areaLabel: FloatingTextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var keyboardHandler: KeyboardHandler?
    
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
        areaLabel.setPlaceholder(text: "user_description_area".localized)
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
        showAreaPickerView()
    }
    
    private func showSexPickerView() {
        let alert = UIAlertController(style: .actionSheet, title: "Вибери стать", message: "")
        
        let frameSizes: [CGFloat] = (150...400).map { CGFloat($0) }
        let pickerViewValues: [[String]] = [frameSizes.map { Int($0).description }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: frameSizes.index(of: 216) ?? 0)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    vc.preferredContentSize.height = frameSizes[index.row]
                }
            }
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    private func showAreaPickerView() {
        let alert = UIAlertController(style: .actionSheet, title: "Вибери станицю", message: "")
        
        let frameSizes: [CGFloat] = (150...400).map { CGFloat($0) }
        let pickerViewValues: [[String]] = [frameSizes.map { Int($0).description }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: frameSizes.index(of: 216) ?? 0)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    vc.preferredContentSize.height = frameSizes[index.row]
                }
            }
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
}
