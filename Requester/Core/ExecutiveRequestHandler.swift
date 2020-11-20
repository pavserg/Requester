//
//  ExecutiveRequestHandler.swift
//  Requester
//
//  Created by Pavlo Dumyak on 20.11.2020.
//

import Foundation

class ExecutiveRequestHandler: RequestHandler {
    
    override func processRequest<T>(request: Request, error: Error?, type: T.Type) where T : Decodable {
        var error = error
        
        let serviceRequest = request.buildURLRequest()
        
        let methodStart = Date()
        let semaphore = DispatchSemaphore.init(value: 0)
        let task = URLSession.shared.dataTask(with: serviceRequest) { data, response, networkError in
          
            if request.canceled {
                print("request cancelled: \(request)")
            } else if let networkError = networkError {
                error = networkError
            }
            
            let methodFinish = Date()
            let executionTime = methodFinish.timeIntervalSince(methodStart)
            URLSession.shared.reset {}
            semaphore.signal()
        }
        
        task.resume()
        
        if semaphore.wait(timeout: DispatchTime.distantFuture) == .timedOut {
            // TODO: handle timeout (throw error)
        }
        
        super.processRequest(request: request, error: error, type: type)
    }
}
