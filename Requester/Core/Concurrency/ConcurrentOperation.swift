//
//  OperationQueue.swift
//  Requester
//
//  Created by Pavlo Dumyak on 20.11.2020.
//

import Foundation
import UIKit

enum ConcurrentOperationState: String {
    case ready, executing, finished
    
    var keyPath: String {
        return "is" + rawValue
    }
}

class ConcurrentOperation: Operation {
    
    var requestBlock: (() -> Void)?
  
    var state = ConcurrentOperationState.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    private var _isAsync: Bool = true
    
    var isAsync: Bool {
        set {
            _isAsync = newValue
        }
        get {
            return _isAsync
        }
    }
    
    init(requestBlock: (() -> Void)?) {
        self.requestBlock = requestBlock
        super.init()
    }
    
    override init() {
        super.init()
    }
}

extension ConcurrentOperation {
    override public var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override public var isExecuting: Bool {
        return state == .executing
    }
    
    override public var isFinished: Bool {
        return state == .finished
    }
    
    override public var isAsynchronous: Bool {
        return isAsync
    }
    
    override public func start() {
        if isCancelled {
            state = .finished
            return
        }
        state = .executing
        main()
        state = .finished
    }
    
    override public func cancel() {
        state = .finished
    }
}
