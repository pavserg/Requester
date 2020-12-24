//
//  QuestionTableViewCell.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 07.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var lineAboveView: UIView!
    @IBOutlet weak var lineBelowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fillWith(info: Topic, isSelected: Bool = false) {
        questionLabel.text = info.question
        
        if isSelected {
            checkmarkImageView.image = UIImage.init(named: "select")
        } else {
            checkmarkImageView.image = UIImage.init(named: "radio-button-false")
        }
    }
}
