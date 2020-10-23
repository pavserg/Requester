//
//  StartViewController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 07.07.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainInformationLabel: UILabel!
    @IBOutlet weak var additionalInformationLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupUI() {
        titleLabel.text = "scout_list_title".localized
        mainInformationLabel.halfTextColorChange(fullText: "start_page_hello_i_am_yours".localized + "start_page_scout_list".localized, changeText: "start_page_scout_list".localized)
        
        additionalInformationLabel.text =   "start_page_useful_scout_list".localized
        
        continueButton.setTitleColor(AppColors.white, for: .normal)
        continueButton.setTitle("start_page_how_does_it_work".localized, for: .normal)
        continueButton.backgroundColor = AppColors.green
        continueButton.layer.cornerRadius = 8.0
     
        loginButton.halfTextColorChange(fullText:  "start_page_already_have_an_account".localized, changeText:  "start_page_already_have_an_account_range_check".localized)
    }
    
    @IBAction func showOnboarding(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
}
