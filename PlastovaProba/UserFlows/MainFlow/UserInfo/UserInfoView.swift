//
//  UserInfoView.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 18.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

protocol UserInfoViewDelegate: class {
    func showRangPicker()
}

class UserInfoView: UIView {
    
    private var view: UIView!
    
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var needToCompleteLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var initialsNameLabel: UILabel!
    @IBOutlet weak var userImagePlaceholderView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var rangPlaceholderView: UIView!
    @IBOutlet weak var rangLabel: UILabel!
    @IBOutlet weak var rangButton: UIButton!
    
    weak var delegate: UserInfoViewDelegate?
    
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
        rangPlaceholderView.backgroundColor = AppColors.green
        rangLabel.textColor = UIColor.white
        userImagePlaceholderView.backgroundColor = AppColors.green
    }
    
    func setInitials(name: String) {
        var initials = initialsFromName(name: name)
        initialsNameLabel.text = initials
    }
    
    func setRang(string: String?) {
        rangPlaceholderView.layer.cornerRadius = 10
        guard let unwrapped = string else { return }
        switch unwrapped {
        case "sympathizer":
            rangLabel.text = "Відзнака Прихильника"
        case "first_challenge":
            rangLabel.text = "Перша Проба"
        case "second_challenge":
            rangLabel.text = "Друга Проба"
        default:
            break
        }
    }
    
    private func initialsFromName(name: String?) -> String {
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
    
    @IBAction func showRangPicker(_ sender: Any) {
        delegate?.showRangPicker()
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
