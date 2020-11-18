//
//  RegistrationDataSourceModel.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 18.11.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import Foundation

class Empty: Decodable {
    
}

class RegistrationDataSourceModel  {
    
    func register(email: String, type: RegistrationViewController.RegistrationType, onCompletion: @escaping ((Bool) -> Void)) {
        let parameters = ["role": type.rawValue] as? [String: AnyObject]
        let requestManger = RequestManager(url: "http://localhost:8080/user/register", params: parameters, requestType: .post)
        
        requestManger.onSuccess = { _, _ in
            onCompletion(true)
        }
        
        requestManger.onFail = { _ in
            onCompletion(false)
        }
        
        requestManger.doRequest(responseType: Empty.self)
    }
    
    func updateUserInfo(firstName: String,
                        lastName: String,
                        sex: String,
                        birthdate: Int64,
                        onCompletion: @escaping ((Bool) -> Void)) {
        
        let parameters = ["firstName": firstName,  "lastName": lastName, "sex": sex, "age": birthdate] as? [String: AnyObject]
        
        let requestManger = RequestManager(url: "http://localhost:8080/user/update", params: parameters, requestType: .post)
        
        requestManger.onSuccess = { _, _ in
            onCompletion(true)
        }
        
        requestManger.onFail = { _ in
            onCompletion(false)
        }
        requestManger.doRequest(responseType: Empty.self)
    }
}
