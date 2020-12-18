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
    
    func fillWith(info: Topic) {
        questionLabel.text = info.question
    }
}
