//
//  CommonAlert.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 21.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

class CommonAlert {
    
    static func showError(title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "Зрозуміло", style: .cancel, handler: nil)
            alert.addAction(ok)
            UIApplication.shared.delegate?.window??.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}
