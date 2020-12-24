//
//  ErrorHandlerProtocol.swift
//  Requesto
//
//  Created by Pavlo Dumyak on 24.12.2020.
//

import UIKit

public protocol ErrorHandlerProtocol: class {
    func handleError(data: Data?, response: URLResponse?) -> Error
}

public struct DefaultError: Error {
    var message: String
    var code: Int
}

class DefaultErrorHandler: ErrorHandlerProtocol {
    func handleError(data: Data?, response: URLResponse?) -> Error {
        if let unwrappedData = data, let httpResponse = response as? HTTPURLResponse  {
            if let string = String(data: unwrappedData, encoding: .utf8) {
                return DefaultError(message: string, code: httpResponse.statusCode)
            }
        }
        
        return DefaultError(message: "Oooops I did it again!", code: 400)
    }
}
