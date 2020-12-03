//
//  RequestHeader.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 03.12.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//

import Requesto

class RequestHeader: Header {
    
    static let shared = RequestHeader()
    
    var headers: [String : String] = [:]
    
    private init() {
        headers["Accept"] = accept
        headers["Content-Type"] = contentType
        headers["Accept-Language"] = acceptLanguage
    }
    
    public func commonHeaders() -> [String: String] {
        headers["Content-Type"] = "application/json"
        headers["Authorization"] = "Bearer \(Token.accessToken)"
        return headers
    }
    
    public func add(header: String, for key: String) {
        headers[key] = header
    }
}
