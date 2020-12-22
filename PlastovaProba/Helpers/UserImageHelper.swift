//
//  UserImageHelper.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 22.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import Foundation
import FirebaseStorage

class UserImageHelper {
    
    static let shared = UserImageHelper()
    
    var profileImageUrl: String?
    
    private init() {
        updateUrl(onCompletion: nil)
    }
    
    func updateUrl(onCompletion: (() -> Void)?) {
        guard let scoutId = Scout.currentUser?.id else { return }
        let storageRef = Storage.storage().reference().child("\(scoutId).png")
        storageRef.downloadURL { (url, error) in
            if error == nil {
                self.profileImageUrl = url?.absoluteString
            }
            onCompletion?()
        }
    }
    
    func photoUrlFor(scoutId: String, onCompletion: @escaping ((String?) -> Void)) {
        let storageRef = Storage.storage().reference().child("\(scoutId).png")
        storageRef.downloadURL { (url, error) in
            onCompletion(url?.absoluteString)
        }
    }
}
