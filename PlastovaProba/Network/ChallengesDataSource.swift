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
        }.executeAsync(parseAs: Challenge.self)
    }
    
    func getFirstChallenge(onCompletion: ((Challenge?, Error?) -> Void)?) {
        Request(owner: ObjectIdentifier(self), url: "http://localhost:8080/application/firstApplication", requestType: .get, parameters: nil, headers: RequestHeader.shared) { response in
            if let firstChallenge = response?.parsedObject as? Challenge {
                onCompletion?(firstChallenge, nil)
            }
        } onFail: { error in
            onCompletion?(nil, error.error)
        }.executeAsync(parseAs: Challenge.self)
    }
    
    func getSecondChallenge(onCompletion: ((Challenge?, Error?) -> Void)?) {
        Request(owner: ObjectIdentifier(self), url: "http://localhost:8080/application/secondApplication", requestType: .get, parameters: nil, headers: RequestHeader.shared) { response in
            if let firstChallenge = response?.parsedObject as? Challenge {
                onCompletion?(firstChallenge, nil)
            }
        } onFail: { error in
            onCompletion?(nil, error.error)
        }.executeAsync(parseAs: Challenge.self)
    }
}
