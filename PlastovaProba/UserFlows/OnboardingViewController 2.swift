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
    @IBOutlet weak var pageControl: JXPageControlExchange!
    
    var pageController: ContainerPageVC!

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
        
        pageControl.activeColor = AppColors.green ?? UIColor.black
        pageControl.inactiveColor = AppColors.inactive
        pageControl.numberOfPages = 4
        pageControl.activeSize = CGSize.init(width: 15, height: 10)
    }
    
    private func setupLocalization() {
        trailingTopButton.setTitle("onboarding_skip".localized, for: .normal)
        trailingTopButton.setTitleColor(AppColors.green, for: .normal)
        leadingTopTitleLabel.text = "scout_list_title".localized
        nextButtonTitleLabel.text = "onboarding_next".localized
    }
    
    @IBAction func showNext(_ sender: Any) {
        pageController.next()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ContainerPageVC {
            pageController = destination
            if let scrollView = destination.view.subviews.filter({$0.isKind(of: UIScrollView.self)}).first as? UIScrollView {
                scrollView.delegate = self
                destination.pageControl = self.pageControl
            }
        }
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isTracking {
            let progress = scrollView.contentOffset.x / scrollView.bounds.width
           // pageControl.progress = progress
        }
    }
}
