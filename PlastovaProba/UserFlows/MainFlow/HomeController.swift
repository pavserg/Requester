//
//  MainController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 04.11.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

protocol HomeCoordinator: class {
    func push(viewController: UIViewController?, isNavigationBarHidden: Bool)
}

class HomeController: UIViewController, HomeCoordinator {
    
    @IBOutlet weak var accountButtonPlaceholderView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupContainerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        headerLabel.font = AppFonts.monteseratBold24
        headerLabel.text = "scout_list_title".localized
        accountButtonPlaceholderView.layer.cornerRadius = accountButtonPlaceholderView.frame.width/2
    }
    
    func setupContainerView() {
        let storyboard = UIStoryboard(name: "MainFlow", bundle: nil)
        let scoutListController = storyboard.instantiateViewController(withIdentifier: "ScoutListController") as? ScoutListController
        scoutListController?.coordinator = self
        add(asChildViewController: scoutListController!)
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
}
