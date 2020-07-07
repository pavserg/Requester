//
//  OnboardingSlideViewController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 30.06.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

class OnboardingSlideViewController: UIViewController {
    
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideTitleLabel: UILabel!
    @IBOutlet weak var slideSubtitleLabel: UILabel!
    
    var data: SlideData?

    struct SlideData {
        let title: String
        let subtitle: String
        let imageName: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLocalization()
    }
    
    func setupUI() {
        if let imageName = data?.imageName {
            slideImageView.image = UIImage(named: imageName)
        }
    }
    
    func setupLocalization() {
        slideTitleLabel.text = data?.title
        slideSubtitleLabel.text = data?.subtitle
    }
}
