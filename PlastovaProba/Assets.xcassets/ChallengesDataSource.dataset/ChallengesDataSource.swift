//
//  ChallengesDataSource.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 18.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import Foundation
import Requesto

class ChallengesDataSource {
    
    func getGeneralChallenge(onCompletion: ((Challenge?, Error?) -> Void)?) {
        Request(owner: ObjectIdentifier(self), url: "http://127.0.0.1:8080/application/generalApplication", requestType: .get, parameters: nil, headers: RequestHeader.shared) { response in
            if let firstChallenge = response?.parsedObject as? Challenge {
                onCompletion?(firstChallenge, nil)
            }
        } onFail: { error in
            onCompletion?(nil, error.error)
        }.executeSync(parseAs: Challenge.self)
    }
    
    func getFirstChallenge(onCompletion: ((Challenge?, Error?) -> Void)?) {
        Request(owner: ObjectIdentifier(self), url: "http://localhost:8080/application/firstApplication", requestType: .get, parameters: nil, headers: RequestHeader.shared) { response in
            if let firstChallenge = response?.parsedObject as? Challenge {
                onCompletion?(firstChallenge, nil)
            }
        } onFail: { error in
            onCompletion?(nil, error.error)
        }.executeSync(parseAs: Challenge.self)
    }
    
    func getSecondChallenge(onCompletion: ((Challenge?, Error?) -> Void)?) {
        Request(owner: ObjectIdentifier(self), url: "http://localhost:8080/application/secondApplication", requestType: .get, parameters: nil, headers: RequestHeader.shared) { response in
            if let firstChallenge = response?.parsedObject as? Challenge {
                onCompletion?(firstChallenge, nil)
            }
        } onFail: { error in
            onCompletion?(nil, error.error)
        }.executeSync(parseAs: Challenge.self)
    }
    
    // MARK: - Get active challenge by id
    
    func activeChallengeBy(id: String, onCompletion: @escaping (([String: Bool]?, Error?) -> Void)) {
       let url = "http://localhost:8080/application/activeChallengeById/\(id)"
     
        Request(owner: ObjectIdentifier(self), url: url, requestType: .get, parameters: nil, headers: RequestHeader.shared) { response in
            if let result = response?.parsedObject as? [String: Bool] {
                onCompletion(result, nil)
            }
          
        } onFail: { error in
            onCompletion(nil, error.error)
        }.executeSync(parseAs: [String: Bool].self)
    }
    
    // MARK: - Update challenge point
    
    func update(userIdentifier: String, pointIdentifier: String, rang: String, onCompletion: @escaping ((Error?) -> Void)) {
        let url = "http://localhost:8080/application/updateSympathizer"
        
        let params = ["id": userIdentifier, "rang": rang, "pointId": pointIdentifier]
        
        Request(owner: ObjectIdentifier(self), url: url, requestType: .post, parameters: params, headers: RequestHeader.shared) { response in
            onCompletion(nil)
        } onFail: { error in
            onCompletion(error.error)
        }.executeSync(parseAs: Empty.self)
    }
}
