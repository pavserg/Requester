//
//  CentralRequestHandler.swift
//  Requester
//
//  Created by Pavlo Dumyak on 20.11.2020.
//

import Foundation

open class CentralRequestHandler: RequestHandler {
 
    private lazy var syncRequestQueue = OperationQueue()
    private lazy var asyncRequestQueue = OperationQueue()
    private var currentRequests = Set<(Request)>()
    private var failedRequests = Set<Request>()
    
    override init() {
        super.init()
        asyncRequestQueue.maxConcurrentOperationCount = 10
        syncRequestQueue.maxConcurrentOperationCount = 1
    }
    
    public func delayFailedRequests() {
        failedRequests = currentRequests
    }
    
    public func processFailedRequests() {
        failedRequests.forEach { (request) in
            request.canceled = false
            request.completed = false
            processFor(request: request)
        }
        failedRequests.removeAll()
    }
    
    private func processFor(request: Request) {
       
    }
    
    public func removeDelayedRequests() {
        failedRequests.removeAll()
    }
    
    override func processRequestAsynchronously<T: Decodable>(request: Request, error: Error?, type: T.Type) {
        currentRequests.insert(request)
        let operation = RequestOperation {
            super.processRequestAsynchronously(request: request, error: error, type: type)
        }

        asyncRequestQueue.addOperation(operation)
    }
    
    override func processRequestSynchronously<T>(request: Request, error: Error?, type: T.Type) where T : Decodable {
        currentRequests.insert(request)
        let operation = RequestOperation {
            super.processRequestSynchronously(request: request, error: error, type: type)
        }
        operation.isAsync = false
        syncRequestQueue.addOperation(operation)
    }
    
    override func reportRequest(request: Request, error: Error?) {
        self.currentRequests.remove(request)
        super.reportRequest(request: request, error: error)
    }
    
    override func cancelAllRequests(owner: ObjectIdentifier) {
        let requestsToCancel = currentRequests.filter({$0.requestOwner() == owner})
        requestsToCancel.forEach { (request) in
            _ = request.cancel()
        }
        currentRequests.subtract(requestsToCancel)
    }
    
    override func cancel() {
      
        currentRequests.forEach { (request) in
            _ = request.cancel()
        }
        currentRequests.removeAll()
    }
    
    override func cancelAllRequests(of kind: Request.Type) {
        let requestsToCancel = currentRequests.filter({type(of: $0) == kind })
        requestsToCancel.forEach { (request) in
            _ = request.cancel()
        }
        currentRequests.subtract(requestsToCancel)
    }
}

extension NSError {
    func isNetworkConnectionError() -> Bool {
        if let err = self as? URLError, err.code  == URLError.Code.notConnectedToInternet {
            return true
        }
        return false
    }
}
