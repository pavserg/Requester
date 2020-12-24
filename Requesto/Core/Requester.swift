//
//  Requester.swift
//  Requesto
//
//  Created by Pavlo Dumyak on 20.11.2020.
//

import Foundation

open class Requester {
    
    static public let shared = Requester()
    
    private var errorHandler: ErrorHandlerProtocol?
    
    private var centralRequestHandler = CentralRequestHandler()
    
    private init() {
        centralRequestHandler.nextHandler = ExecutiveRequestHandler()
    }
    
    public func setError(handler: ErrorHandlerProtocol) {
        errorHandler = handler
    }
    
    func getErrorHandler() -> ErrorHandlerProtocol? {
        if errorHandler == nil  {
            return DefaultErrorHandler()
        }
        return errorHandler
    }
    
    func processRequestAsynchronously<T: Decodable>(request: Request, type: T.Type) {
        centralRequestHandler.processRequestAsynchronously(request: request, error: nil, type: type)
    }
    
    func processRequestSynchronously<T: Decodable>(request: Request, type: T.Type) {
        centralRequestHandler.processRequestSynchronously(request: request, error: nil, type: type)
    }
    
    func processDownloadRequest(request: DownloadRequest) {
        centralRequestHandler.processDownloadRequest(request: request, error: nil)
    }
    
    public func cancelAllRequests(owner: ObjectIdentifier) {

    }
    
    public func cancellAllRequests() {
  
    }
}
