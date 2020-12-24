//
//  AddNewScoutTableViewCell.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 04.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

class AddNewScoutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addButton.backgroundColor = .white
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = AppColors.green?.cgColor
        addButton.layer.cornerRadius = 8.0
        addButton.setTitleColor(AppColors.green, for: .normal)
        addButton.setTitle("Додати в гурток".localized, for: .normal)
        addButton.isUserInteractionEnabled = false
    }
}
