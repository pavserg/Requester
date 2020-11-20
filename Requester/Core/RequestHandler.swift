//
//  RequestHandler.swift
//  Requester
//
//  Created by Pavlo Dumyak on 20.11.2020.
//

import Foundation

open class RequestHandler {
    
    var previousHandler: RequestHandler?
    var nextHandler: RequestHandler? {
        didSet {
            nextHandler?.previousHandler = self
        }
    }
    
    func processRequestAsynchronously<T: Decodable>(request: Request, error: Error?, type: T.Type) {
        if let handler = nextHandler, !request.completed && !request.canceled && error == nil {
            handler.processRequestAsynchronously(request: request, error: error, type: type)
        } else {
            request.completed = true
            reportRequest(request: request, error: error)
        }
    }
    
    func processRequestSynchronously<T: Decodable>(request: Request, error: Error?, type: T.Type) {
        if let handler = nextHandler, !request.completed && !request.canceled && error == nil {
            handler.processRequestSynchronously(request: request, error: error, type: type)
        } else {
            request.completed = true
            reportRequest(request: request, error: error)
        }
    }
    
    func reportRequest(request: Request, error: Error?) {
        if request.canceled {
            return
        }
        if let handler = self.previousHandler {
            handler.reportRequest(request: request, error: error)
        } else if let closure = request.onFail, let unwrappedError = error {
            closure(Request.FailResponse(response: nil, error: unwrappedError))
        }
    }
    
    func cancelAllRequests(owner: ObjectIdentifier) {}
    
    func cancelAllRequests(of kind: Request.Type) {}
    
    func cancel() {}
}
