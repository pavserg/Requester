//
//  Headers.swift
//  Requesto
//
//  Created by Pavlo Dumyak on 20.11.2020.
//

public protocol Header: class {
    
    var headers: [String: String] { get set }
    
    var accept: String { get }
    
    var contentType: String { get }
    
    var contentTypeUrlEncoded: String { get }
    
    var acceptLanguage: String { get }
    
    func commonHeaders() -> [String: String]
    
    func add(header: String, for key: String)
    
    func setCustomContentType(value: String)
    
    func isUrlEncoded() -> Bool
}

extension Header {
    public var accept: String {
        "application/json"
    }
    
    public var contentType: String {
        "application/json; charset=UTF-8"
    }
    
    public var acceptLanguage: String {
        "en;q=1"
    }
    
    public var contentTypeUrlEncoded: String {
        "application/x-www-form-urlencoded"
    }
    
    public func commonHeaders() -> [String: String] {
        headers
    }
    
    public func add(header: String, for key: String) {
        headers[key] = header
    }
    
    public func setCustomContentType(value: String) {
        headers["Content-Type"] = value
    }
    
    public func isUrlEncoded() -> Bool {
        return headers["Content-Type"] == contentTypeUrlEncoded
    }
}

public class HTTPHeader: Header {
    
    public var headers: [String: String] = [:]
    
    public init() {
        headers["Accept"] = accept
        headers["Content-Type"] = contentType
        headers["Accept-Language"] = acceptLanguage
    }
}
