//
//  ErrorHandler.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 24.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit
import Requesto

struct ErrorModel: Error, Decodable {
    var error: Bool
    var code: Int?
    var reason: String?
}

class ErrorHandler: ErrorHandlerProtocol {
    func handleError(data: Data?, response: URLResponse?) -> Error {
        if let unwrappedData = data, let httpResponse = response as? HTTPURLResponse  {
            var error = try? JSONDecoder().decode(ErrorModel.self, from: unwrappedData)
            error?.code = httpResponse.statusCode
            
            return error ?? ErrorModel(error: true, reason: "Oooops I did it again!")
        }
        
        return ErrorModel(error: true, reason: "Oooops I did it again!")
    }
}
