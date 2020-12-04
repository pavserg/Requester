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
        
        
        
        Auth.auth().signIn(withEmail: "p.dumyak@gmail.com", password: "123456") { (result, error) in
            DispatchQueue.main.async {
                if let unwrappedResult = result {
                   
                    unwrappedResult.user.getIDToken { (token, error) in
                        Token.accessToken = token!
                        print(token)
                    }
                }
            }
        }
        
        return true
    }
}

