//
//  Requester.swift
//  Requester
//
//  Created by Pavlo Dumyak on 20.11.2020.
//

import Foundation

class Requester {
    
    static let shared = Requester()
    
    private var centralRequestHandler = CentralRequestHandler()
    
    private init() {
        centralRequestHandler.nextHandler = ExecutiveRequestHandler()
    }
    
    public func processRequest<T: Decodable>(request: Request, type: T.Type) {
        centralRequestHandler.processRequest(request: request, error: nil, type: type)
    }
    
    public func cancelAllRequests(owner: ObjectIdentifier) {

    }
    
    public func cancellAllRequests() {
  
    }
}
