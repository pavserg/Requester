//
//  RequestOperation.swift
//  Requester
//
//  Created by Pavlo Dumyak on 20.11.2020.
//

import Foundation

class RequestOperation: ConcurrentOperation {
  
    override init(requestBlock: (() -> Void)?) {
        super.init()
        self.requestBlock = requestBlock
    }
    
    override public func main() {
        requestBlock?()
        
        state = .finished
    }
}
