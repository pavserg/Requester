//
//  Request.swift
//  Requesto
//
//  Created by Pavlo Dumyak on 20.11.2020.
//

import Foundation

open class Request {
    
    public class DownloadSuccessResponse {
        public let location: URL?
       
        init(location: URL?) {
            self.location = location
        }
    }

    public class SuccessResponse {
        public let response: URLResponse?
        public let object: Data?
        public let parsedObject: AnyObject?
        
        init(response: URLResponse?, object: Data?, parsedObject: AnyObject?) {
            self.response = response
            self.object = object
            self.parsedObject = parsedObject
        }
    }

    public class FailResponse {
        public let response: URLResponse?
        public let error: Error?
        
        init(response: URLResponse?, error: Error?) {
            self.response = response
            self.error = error
        }
    }
    
    public enum RequestType: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
        case head = "HEAD"
    }
    
    // MARK: - Request life cycle
    var completed = false
    var canceled = false
    
    // reporting
    var onFail: ((_ response: FailResponse) -> Void)?
    var onSuccess: ((_ response: SuccessResponse?) -> Void)?
    
    let owner: ObjectIdentifier
    let url: String?
    let parameters: [String: Any]?
    let headers: Header?
    let requestType: RequestType?
    var parsingType: NSObject.Type?
    
    public init(owner: ObjectIdentifier,
                url: String,
                requestType: RequestType,
                parameters: [String: Any]? = nil,
                headers: Header? = HTTPHeader(),
                onSuccess: ((SuccessResponse?) -> Void)?,
                onFail: @escaping ((FailResponse) -> Void)) {
        self.owner = owner
        self.requestType = requestType
        self.parameters = parameters
        self.url = url
        self.headers = headers
        self.onSuccess = onSuccess
        self.onFail = onFail
    }
    
    func buildURLRequest() -> URLRequest {
        var request = URLRequest(url: URL(string: url!)!)
    
        if let method = self.requestType?.rawValue {
            request.httpMethod = method
        }
        
        if let parameters = parameters, parameters.isEmpty == false {
            if headers?.isUrlEncoded() ?? false {
                request.httpBody = componentsQuery()
            } else {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
                } catch {
                    assertionFailure("Can't serialize dict to Data")
                }
            }
        }
        
        if let headers = headers {
            request.allHTTPHeaderFields = headers.commonHeaders()
        }
        
        // MARK: - Request Info
        #if DEBUG
        print("""
            \n============================= REQUEST INFO ====================================
            \(request.curlString)
            ==================================================================================\n
            """)
        #endif
        
        return request
    }
    
    private func componentsQuery() -> Data? {
        let allKeys = parameters?.keys
        var components = URLComponents()
        var queryItems: [URLQueryItem] = []
        
        allKeys?.forEach({ (key) in
             if let value = parameters?[key] as? String {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
        })
    
        components.queryItems = queryItems
        return components.query?.data(using: .utf8)
    }
    
    func requestOwner() -> ObjectIdentifier {
        owner
    }
    
    func cancel() -> Bool {
        if canceled {
            return false
        }
        canceled = true
        return canceled
    }
    
    public func executeAsync<T: Decodable>(parseAs: T.Type) {
        parsingType = parseAs as? NSObject.Type
        Requester.shared.processRequestAsynchronously(request: self, type: parseAs)
    }
    
    public func executeSync<T: Decodable>(parseAs: T.Type) {
        parsingType = parseAs as? NSObject.Type
        Requester.shared.processRequestSynchronously(request: self, type: parseAs)
    }
    
    func printServer(error: NSError, for url: String) {
        print("=========================|Server Error BEGIN|======================\n\n")
        print("URL: \(url)\n")
        print(error)
        print("=========================|Server Error END|======================\n\n")
    }
}

extension Request: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    public static func == (lhs: Request, rhs: Request) -> Bool {
        return ObjectIdentifier(lhs).hashValue == ObjectIdentifier(rhs).hashValue
    }
}
