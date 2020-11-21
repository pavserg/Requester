//
//  CentralRequestHandler.swift
//  Requesto
//
//  Created by Pavlo Dumyak on 20.11.2020.
//

import Foundation

open class CentralRequestHandler: RequestHandler {
 
    private lazy var syncRequestQueue = OperationQueue()
    private lazy var asyncRequestQueue = OperationQueue()
    private lazy var downloadRequestQueue = OperationQueue()
    private var currentRequests = Set<(Request)>()
    
    override init() {
        super.init()
        
        asyncRequestQueue.maxConcurrentOperationCount = 10
        syncRequestQueue.maxConcurrentOperationCount = 1
        downloadRequestQueue.maxConcurrentOperationCount = 1
    }
    
    override func processRequestAsynchronously<T: Decodable>(request: Request, error: Error?, type: T.Type) {
        currentRequests.insert(request)
        let operation = RequestOperation {
            super.processRequestAsynchronously(request: request, error: error, type: type)
        }
        asyncRequestQueue.addOperation(operation)
    }
    
    override func processRequestSynchronously<T>(request: Request, error: Error?, type: T.Type) where T : Decodable {
        let operation = RequestOperation {
            self.currentRequests.insert(request)
            super.processRequestSynchronously(request: request, error: error, type: type)
        }
        operation.isAsync = false
        syncRequestQueue.addOperation(operation)
    }
    
    override func processDownloadRequest(request: DownloadRequest, error: Error?) {
        currentRequests.insert(request)
        let operation = RequestOperation {
            super.processDownloadRequest(request: request, error: error)
        }
    
        operation.isAsync = false
        downloadRequestQueue.addOperation(operation)
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
