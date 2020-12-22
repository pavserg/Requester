//
//  MainController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 04.11.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit
import SDWebImage


protocol HomeCoordinator: class {
    func push(viewController: UIViewController?, isNavigationBarHidden: Bool)
}

class HomeController: UIViewController, HomeCoordinator {
    
    @IBOutlet weak var accountButtonPlaceholderView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var initialNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupContainerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        if let unwrappedImageUrl = UserImageHelper.shared.profileImageUrl {
            profileImageView.downloadImage(url: unwrappedImageUrl)
        }
        
    }
    
    private func setupUI() {
        headerLabel.font = AppFonts.monteseratBold24
        headerLabel.text = "scout_list_title".localized
        accountButtonPlaceholderView.layer.cornerRadius = accountButtonPlaceholderView.frame.width/2
        accountButtonPlaceholderView.backgroundColor = AppColors.primaryLine
        if let scout = Scout.currentUser, let firstName = scout.firstName, let lastName = scout.lastName {
            initialNameLabel.text = initialsFromName(name: firstName + " " + lastName )
        }
        
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
    
    func setupContainerView() {
        let storyboard = UIStoryboard(name: "MainFlow", bundle: nil)
        
        if Scout.currentUser?.role == "scout_master" {
            let scoutListController = storyboard.instantiateViewController(withIdentifier: "ScoutListController") as? ScoutListController
            scoutListController?.coordinator = self
            add(asChildViewController: scoutListController!)
        } else if Scout.currentUser?.role == "scout" {
            let applicationController = storyboard.instantiateViewController(withIdentifier: "ApplicationController") as? ApplicationController
            applicationController?.type = .scout
            add(asChildViewController: applicationController!)
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    func push(viewController: UIViewController?, isNavigationBarHidden: Bool = false) {
        if let unwrapped = viewController {
            navigationController?.pushViewController(unwrapped, animated: true)
            navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: true)
        }
    }
    
    @IBAction func openProfile(_ sender: Any) {
        
       // UserDescription
        
       // AddPhotoController
        
        //let storyboard = UIStoryboard(name: "UserDescription", bundle: nil)
        //let profileController = storyboard.instantiateViewController(withIdentifier: "AddPhotoController")
        
       // push(viewController: profileController)
        
        let storyboard = UIStoryboard(name: "MainFlow", bundle: nil)
        let profileController = storyboard.instantiateViewController(withIdentifier: "ProfileController") as? ProfileController
        profileController?.bandModel = (children.first as? ScoutListController)?.dataSource
        
        if let challenge = (children.first as? ApplicationController)?.activeChallenge {
            profileController?.challengePoints = challenge
        }
        
        push(viewController: profileController!)
    }
}

extension UIImageView{
    func downloadImage(url: String) {
        let stringWithoutWhitespace = url.replacingOccurrences(of: " ", with: "%20", options: .regularExpression)
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: URL(string: stringWithoutWhitespace), placeholderImage: UIImage())
    }
}
