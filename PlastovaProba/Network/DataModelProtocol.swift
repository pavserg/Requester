//
//  DataModelProtocol.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 18.11.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import UIKit

protocol DataModelProtocol: class {
    init()
    func parse(data: Data?) -> Any?
}

protocol DataSourceModelProtocol: class {
    associatedtype ItemType
    
    var loadingCompletionClosure: ((_ error: NSError?) -> Void)? { get set }
    func objects() -> [ItemType]?
    func reloadObjects() -> Void
    func isEmpty() -> Bool
}
