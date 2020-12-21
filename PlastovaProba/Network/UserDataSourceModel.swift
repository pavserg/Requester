//
//  UserDataSourceModel.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 21.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import Foundation
import Firebase
import Requesto

class UserDataSourceModel {
    
    func getProfile(onCompletion: ((Scout?, Error?) -> Void)?) {
        
        guard let identifier = Auth.auth().currentUser?.uid else { onCompletion?(nil, nil); return }
        
        let url = "http://localhost:8080/user/scout/\(identifier)"
        
        Request(owner: ObjectIdentifier(self), url: url, requestType: .get, parameters: nil, headers: RequestHeader.shared) { response in
            if let scout = response?.parsedObject as? Scout {
                onCompletion?(scout, nil)
            }
        } onFail: { error in
            onCompletion?(nil, error.error)
        }.executeAsync(parseAs: Scout.self)
    }
    
    func updateRang(rangString: String, identifier: String, onCompletion: ((Scout?, Error?) -> Void)?) {
        let url = "http://localhost:8080/user/updateRang"
        let params = ["id": identifier,
                      "rang": rangString]
        
        Request(owner: ObjectIdentifier(self), url: url, requestType: .post, parameters: params, headers: RequestHeader.shared) { response in
            if let scout = response?.parsedObject as? Scout {
                onCompletion?(scout, nil)
            }
        } onFail: { error in
            onCompletion?(nil, error.error)
        }.executeAsync(parseAs: Scout.self)
    }
}