//
//  Storyboard+Common.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 30.06.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

enum StoryboardName: String {
    case main = "Main"
    case onboarding = "Onboarding"
}

extension UIStoryboard {
    static func getViewController(storyboardName: StoryboardName = .main, controllerIdentifier: String) -> UIViewController? {
        return UIStoryboard(name: storyboardName.rawValue, bundle: nil).instantiateViewController(withIdentifier: controllerIdentifier)
    }
}
