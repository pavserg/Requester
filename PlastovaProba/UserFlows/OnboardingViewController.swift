//
//  ViewController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 30.06.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit
import JXPageControl

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var leadingTopTitleLabel: UILabel!
    @IBOutlet weak var trailingTopButton: UIButton!
    @IBOutlet weak var nextButtonPlaceholderView: UIView!
    @IBOutlet weak var nextButtonTitleLabel: UILabel!
    @IBOutlet weak var nextButtonArrowImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - PageControl
    @IBOutlet weak var pageControlPlaceholder: UIView!
    var pageControl: JXPageControlExchange?
    var pageController: ContainerPageVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLocalization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        nextButtonTitleLabel.text = "onboarding_next".localized
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPageControl()
    }
    
    private func setupUI() {
        nextButtonPlaceholderView.layer.cornerRadius = 5.0
        nextButtonPlaceholderView.backgroundColor = AppColors.green
        nextButtonTitleLabel.textColor = AppColors.white
        leadingTopTitleLabel.textColor = AppColors.black
        nextButtonArrowImageView.image = UIImage(named: "arrow_forward")
        
    }
    
    private func setupPageControl() {
        pageControl = JXPageControlExchange(frame: pageControlPlaceholder.bounds)
        pageControl?.activeColor = AppColors.green ?? UIColor.black
        pageControl?.inactiveColor = AppColors.inactive
        pageControl?.numberOfPages = 4
        pageControl?.activeSize = CGSize.init(width: 15, height: 10)
        pageControlPlaceholder.alpha = 0.0
        if let unwrapped = pageControl {
            pageControlPlaceholder.addSubview(unwrapped)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.pageControlPlaceholder.alpha = 1.0
        }
        
        pageController.pageControl = pageControl
    }
    
    private func setupLocalization() {
        trailingTopButton.setTitle("onboarding_skip".localized, for: .normal)
        trailingTopButton.setTitleColor(AppColors.green, for: .normal)
        leadingTopTitleLabel.text = "scout_list_title".localized
        nextButtonTitleLabel.text = "onboarding_next".localized
    }
    
    @objc func showRegistrationController() {
        let storyboard = UIStoryboard.init(name: "Registration", bundle: nil)
        let registrationController = storyboard.instantiateViewController(withIdentifier: "RegistrationViewController")
        navigationController?.pushViewController(registrationController, animated: true)
    }
    
    @IBAction func showNext(_ sender: Any) {
        if pageControl?.currentPage == (pageController?.controllers.count ?? 90) - 1 {
             showRegistrationController()
             pageControl?.removeFromSuperview()
        }
        
        if pageController.next() {
            nextButtonTitleLabel.text = "Реєстрація".localized
        } else {
            nextButtonTitleLabel.text = "onboarding_next".localized
        }
    }
    
    @IBAction func skip(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ContainerPageVC {
            pageController = destination
            destination.pageControl = self.pageControl
        }
    }
}
