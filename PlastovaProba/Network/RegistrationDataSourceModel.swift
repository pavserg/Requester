//
//  RegistrationDataSourceModel.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 18.11.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import Foundation
import Requester

class Empty: Decodable {
    
}

class RegistrationDataSourceModel  {
    
    func register(email: String, type: RegistrationViewController.RegistrationType, onCompletion: @escaping ((Bool) -> Void)) {
       // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("Bearer \(Token.accessToken)", forHTTPHeaderField: "Authorization")
        let parameters = ["role": type.rawValue] as? [String: AnyObject]
        Request(owner: ObjectIdentifier(self), url: "http://localhost:8080/user/register", requestType: .post, parameters: parameters) { response in
            onCompletion(true)
        } onFail: { error in
            onCompletion(false)
        }.executeAsync(parseAs: Empty.self)
    }
    
    func updateUserInfo(firstName: String,
                        lastName: String,
                        sex: String,
                        birthdate: Int64,
                        onCompletion: @escaping ((Bool) -> Void)) {
        
        let parameters = ["firstName": firstName,  "lastName": lastName, "sex": sex, "age": birthdate] as? [String: AnyObject]
        Request(owner: ObjectIdentifier(self), url: "http://localhost:8080/user/update", requestType: .post, parameters: parameters) { response in
            onCompletion(true)
        } onFail: { error in
            onCompletion(false)
        }.executeAsync(parseAs: Empty.self)
    }
}
