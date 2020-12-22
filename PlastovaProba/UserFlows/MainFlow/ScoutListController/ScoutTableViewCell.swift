//
//  ScoutTableViewCell.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 04.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit
import SwipeCellKit

class ScoutTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rangLabel: UILabel!
    @IBOutlet weak var avatarPlaceholderView: UIView!
    @IBOutlet weak var initialNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarPlaceholderView.layer.cornerRadius = avatarPlaceholderView.frame.width/2
    }
    
    func setupInfo(scout: Scout?) {
        nameLabel.text = (scout?.firstName ?? "") + " " + ((scout?.lastName) ?? "")
        avatarPlaceholderView.backgroundColor = AppColors.green
        
        initialNameLabel.text = initialsFromName(name: nameLabel.text!)
    }
    
    func initialsFromName(name: String?) -> String {
        var initials = ""
        let nameComponents = name?.components(separatedBy: " ")
        switch nameComponents?.count {
        case 1:
            guard let component = nameComponents?[0] else { return "" }
            if component.count > 1 {
                initials.append(contentsOf: String(component.prefix(2)).uppercased())
            } else {
                if let first = component.first {
                    initials.append(first.uppercased())
                }
            }
        default:
            if let first = nameComponents?[0].first {
                initials.append(first.uppercased())
            }
            if let second = nameComponents?[1].first {
                initials.append(second.uppercased())
            }
        }
        return initials
    }
}
