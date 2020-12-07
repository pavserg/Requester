//
//  GategoryCollectionViewCell.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 07.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

class GategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        layer.cornerRadius = 10
        
    }
    
    func fillWithInfo() {
        backgroundColor = AppColors.green
        titleLabel.text = "Усі точки\nпроби"
        titleLabel.textColor = UIColor.white
        progressLabel.text = "Здано 21 з 53"
        progressLabel.textColor = UIColor.white
    }
}
