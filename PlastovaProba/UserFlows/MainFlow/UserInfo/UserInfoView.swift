//
//  UserInfoView.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 18.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

class UserInfoView: UIView {
    
    private var view: UIView!
    
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var needToCompleteLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImagePlaceholderView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var rangPlaceholderView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupXib()
    }
    
    private func setupUI() {
        userImagePlaceholderView.layer.cornerRadius = userImagePlaceholderView.frame.width/2
    }
    
    func setupXib() {
        view = loadNib()
        view.frame = bounds
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view as UIView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view as UIView]))
        setupUI()
    }
}
