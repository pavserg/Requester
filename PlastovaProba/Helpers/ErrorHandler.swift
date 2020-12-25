//
//  ErrorHandler.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 24.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit
import Requesto
import FirebaseAuth

struct ErrorModel: Error, Decodable {
    var error: Bool
    var code: Int?
    var reason: String?
}

class ErrorHandler: ErrorHandlerProtocol {
    func handleError(data: Data?, response: URLResponse?) -> Error {
        if let urlResponse = response as? HTTPURLResponse  {
            if urlResponse.statusCode == 401 {
                Auth.auth().currentUser?.getIDTokenResult(forcingRefresh: true, completion: { (token, error) in
                    if error == nil {
                        Token.accessToken = token?.token ?? ""
                    } else {
                        DispatchQueue.main.async {
                            try? Auth.auth().signOut()
                            self.loadStartController()
                        }
                    }
                })
            }
            
            
            if let unwrappedData = data {
                var error = try? JSONDecoder().decode(ErrorModel.self, from: unwrappedData)
                error?.code = urlResponse.statusCode
                
                return error ?? ErrorModel(error: true, reason: "Oooops I did it again!")
            }
        }
        
        return ErrorModel(error: true, reason: "Oooops I did it again!")
    }
    
    private func loadStartController() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "StartViewNavigationController")
            UIApplication.shared.delegate?.window??.rootViewController = controller
        }
    }
}
