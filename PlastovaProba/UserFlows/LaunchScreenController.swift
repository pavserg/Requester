//
//  LaunchScreenController.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 24.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LaunchScreenController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        proceedWorkflow()
    }
    
    private func proceedWorkflow() {
        if Auth.auth().currentUser != nil {
            Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { (token, error) in
                if error == nil {
                    Token.accessToken = token ?? ""
                    UserDataSourceModel().getProfile { (userProfile, error) in
                        if error == nil {
                            Scout.currentUser = userProfile
                            
                            if Scout.currentUser?.firstName == nil && Scout.currentUser?.lastName == nil && Scout.currentUser?.age == nil && Scout.currentUser?.sex == nil {
                                self.loadUserDescriptionController()
                                return
                            }
                            
                            UserImageHelper.shared.updateUrl(onCompletion: {
                                self.loadHomeController(user: userProfile)
                            })
                        }
                    }
                } else {
                    try? Auth.auth().signOut()
                    DispatchQueue.main.async {
                        self.loadStartController()
                    }
                }
            })
        } else {
            loadStartController()
        }
    }
    
    private func loadHomeController(user: Scout?) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "MainFlow", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
            UIApplication.shared.delegate?.window??.rootViewController = controller
        }
    }
    
    private func loadStartController() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "StartViewNavigationController")
            UIApplication.shared.delegate?.window??.rootViewController = controller
        }
    }
    
    private func loadUserDescriptionController() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "UserDescription", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "UserDescriptionController")
            let navigationController = UINavigationController(rootViewController: controller)
            UIApplication.shared.delegate?.window??.rootViewController = navigationController
        }
    }
}
