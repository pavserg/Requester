//
//  ViewController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 30.06.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var leadingTopTitleLabel: UILabel!
    @IBOutlet weak var trailingTopButton: UIButton!
    
    @IBOutlet weak var nextButtonPlaceholderView: UIView!
    @IBOutlet weak var nextButtonTitleLabel: UILabel!
    @IBOutlet weak var nextButtonArrowImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLocalization()
    }
    
    private func setupUI() {
        nextButtonPlaceholderView.layer.cornerRadius = 5.0
        nextButtonPlaceholderView.backgroundColor = AppColors.green
        nextButtonTitleLabel.textColor = AppColors.white
        leadingTopTitleLabel.textColor = AppColors.black
        nextButtonArrowImageView.image = UIImage(named: "arrow_forward")
    }
    
    private func setupLocalization() {
        trailingTopButton.setTitle("onboarding_skip".localized, for: .normal)
        trailingTopButton.setTitleColor(AppColors.green, for: .normal)
        leadingTopTitleLabel.text = "scout_list_title".localized
        nextButtonTitleLabel.text = "onboarding_next".localized
    }
    
    @IBAction func showNext(_ sender: Any) {
        
    }
}

