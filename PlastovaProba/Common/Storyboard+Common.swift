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

extension UIView {
    // MARK: - xib
    func loadNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return nil }
        return view
    }
}

extension UIStackView {
    func removeAll() {
        _ = arrangedSubviews.reduce([]) { (_, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            NSLayoutConstraint.deactivate(subview.constraints)
            subview.removeFromSuperview()
            return []
        }
    }
}
