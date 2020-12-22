//
//  AppDelegate.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 30.06.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        
        
        proceedWorkflow()
        
        
      /*  Auth.auth().signIn(withEmail: "p.dumyak@gmail.com", password: "123456") { (result, error) in
            DispatchQueue.main.async {
                if let unwrappedResult = result {
                   
                    unwrappedResult.user.getIDToken { (token, error) in
                        Token.accessToken = token!
                        print(token)
                    }
                }
            }
        }*/
    
        
        return true
    }
    
    private func proceedWorkflow() {
        if Auth.auth().currentUser != nil {
            Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { (token, error) in
                Token.accessToken = token ?? ""
                UserDataSourceModel().getProfile { (userProfile, error) in
                    if error == nil {
                        Scout.currentUser = userProfile
                        UserImageHelper.shared.updateUrl(onCompletion: {
                            self.loadHomeController(user: userProfile)
                        })
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
            self.window = UIWindow.init(frame: UIScreen.main.bounds)
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
        }
    }
    
    private func loadStartController() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "StartViewNavigationController")
            self.window = UIWindow.init(frame: UIScreen.main.bounds)
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
        }
    }
}

