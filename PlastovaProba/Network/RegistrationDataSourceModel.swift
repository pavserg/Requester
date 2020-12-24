//
//  RegistrationDataSourceModel.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 18.11.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import Foundation
import Requesto


let serverUrl = "http://localhost:8080" //"https://scoutappdemoua.herokuapp.com"// "http://91.218.106.227"//"http://localhost:8080"

class Empty: Decodable {}


class AddStatus: Decodable {
    var scoutEmail: String
    var addStatus: Bool
    
    init(scoutEmail: String, addStatus: Bool) {
        self.scoutEmail = scoutEmail
        self.addStatus = addStatus
    }
}

class RegistrationDataSourceModel  {
    
    func register(email: String, type: RegistrationViewController.RegistrationType, onCompletion: @escaping ((Bool) -> Void)) {
        let parameters = ["role": type.rawValue] as [String: AnyObject]
        Request(owner: ObjectIdentifier(self), url: "\(serverUrl)/user/register", requestType: .post, parameters: parameters, headers: RequestHeader.shared) { response in
            onCompletion(true)
        } onFail: { error in
            onCompletion(false)
        }.executeAsync(parseAs: Empty.self)
    }
    
    func updateUserInfo(firstName: String,
                        lastName: String,
                        sex: String,
                        birthdate: Int64,
                        onCompletion: @escaping ((Scout?, Error?) -> Void)) {
        let parameters = ["firstName": firstName, "lastName": lastName, "sex": sex, "age": birthdate] as [String: AnyObject]
        Request(owner: ObjectIdentifier(self), url: "\(serverUrl)/user/update", requestType: .post, parameters: parameters, headers: RequestHeader.shared) { response in
            if let scout = response?.parsedObject as? Scout {
                onCompletion(scout, nil)
            }
           
        } onFail: { error in
            onCompletion(nil, error.error)
        }.executeAsync(parseAs: Scout.self)
    }
    
    func createBand(bandName: String, onCompletion: @escaping ((Bool) -> Void)) {
        let parameters = ["bandName": bandName] as [String: AnyObject]
        Request(owner: ObjectIdentifier(self), url: "\(serverUrl)/user/createBand", requestType: .post, parameters: parameters, headers: RequestHeader.shared) { response in
            onCompletion(true)
        } onFail: { error in
            onCompletion(false)
        }.executeAsync(parseAs: Empty.self)
    }
    
    func addScout(email: String, rang: String, onCompletion: @escaping ((Bool, Error?) -> Void)) {
        let parameters = ["email": email.lowercased(), "rang": rang.lowercased()] as [String: AnyObject]
        Request(owner: ObjectIdentifier(self), url: "\(serverUrl)/user/append", requestType: .post, parameters: parameters, headers: RequestHeader.shared) { response in
            onCompletion(true, nil)
        } onFail: { error in
            onCompletion(false, error.error)
        }.executeAsync(parseAs: AddStatus.self)
    }
    
    func deleteScout(email: String, onCompletion: @escaping ((Bool) -> Void)) {
        let parameters = ["email": email.lowercased()] as [String: AnyObject]
        Request(owner: ObjectIdentifier(self), url: "\(serverUrl)/user/delete", requestType: .post, parameters: parameters, headers: RequestHeader.shared) { response in
            onCompletion(true)
        } onFail: { error in
            onCompletion(false)
        }.executeAsync(parseAs: Empty.self)
    }
    
    func getScouts(onCompletion: ((BandModel?, Error?) -> Void)?) {
        Request(owner: ObjectIdentifier(self), url: "\(serverUrl)/user/scouts", requestType: .get, parameters: nil, headers: RequestHeader.shared) { response in
            if let scouts = response?.parsedObject as? BandModel {
                onCompletion?(scouts, nil)
            }
        } onFail: { error in
            onCompletion?(nil, error.error)
        }.executeSync(parseAs: BandModel.self)
    }
}
