//
//  ScoutTableViewCell.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 04.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

class ScoutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rangLabel: UILabel!
    @IBOutlet weak var avatarPlaceholderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarPlaceholderView.layer.cornerRadius = avatarPlaceholderView.frame.width/2
    }
}
