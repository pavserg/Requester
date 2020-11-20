//
//  CentralRequestHandler.swift
//  Requester
//
//  Created by Pavlo Dumyak on 20.11.2020.
//

import Foundation

open class CentralRequestHandler: RequestHandler {
    
    let serialQueues = [
        DispatchQueue(label: "com.requester.serial_Queue_00"),
        DispatchQueue(label: "com.requester.serial_Queue_01"),
        DispatchQueue(label: "com.requester.serial_Queue_02"),
        DispatchQueue(label: "com.requester.serial_Queue_03")
    ]
    
    private var currentRequests = Set<(Request)>()
    private var failedRequests = Set<Request>()
    
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
    
    override func processRequest<T: Decodable>(request: Request, error: Error?, type: T.Type) {
        currentRequests.insert(request)
        let queue = serialQueues[Int(arc4random_uniform(UInt32(serialQueues.count)))]
        queue.async {
            super.processRequest(request: request, error: error, type: type)
        }
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
