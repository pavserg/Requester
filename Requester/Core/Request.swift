//
//  Request.swift
//  Requester
//
//  Created by Pavlo Dumyak on 20.11.2020.
//

import Foundation

final class Request {
    
    struct SuccessResponse {
        let response: URLResponse
        let object: AnyObject
        let parsedObject: AnyObject
    }

    struct FailResponse {
        let response: URLResponse?
        let error: Error
    }
    
    enum RequestType: String {
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
    
    private let owner: ObjectIdentifier
    private let url: String?
    private let parameters: [String: Any]?
    private let headers: [String: String]?
    private let requestType: RequestType?
    private var parseModel: NSObject.Type?
    
    init(owner: ObjectIdentifier, url: String, requestType: RequestType, parameters: [String: Any]? = nil, headers: [String: String]? = nil) {
        self.owner = owner
        self.requestType = requestType
        self.parameters = parameters
        self.url = url
        self.headers = headers
    }
    
    func buildURLRequest() -> URLRequest {
        var request = URLRequest(url: URL(string: url!)!)
    
        if let method = self.requestType?.rawValue {
            request.httpMethod = method
        }
        
        if let parameters = parameters, parameters.isEmpty == false {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                assertionFailure("Can't serialize dict to Data")
            }
        }
        
        // MARK: - Request Info
        print("\n============================= REQUEST INFO ====================================")
        
        //print(request.curlString)
        
        print("==================================================================================\n")
        
        return request
    }
    
    func requestOwner() -> ObjectIdentifier {
        owner
    }
    
    func setParseModel<T: Decodable>(type: T.Type) {
        parseModel = type as? NSObject.Type
    }
    
    func cancel() -> Bool {
        if canceled {
            return false
        }
        canceled = true
        return canceled
    }
    
    func printServer(error: NSError, for url: String) {
        print("=========================|Server Error BEGIN|======================\n\n")
        print("URL: \(url)\n")
        print(error)
        print("=========================|Server Error END|======================\n\n")
    }
}

extension Request: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    static func == (lhs: Request, rhs: Request) -> Bool {
        return ObjectIdentifier(lhs).hashValue == ObjectIdentifier(rhs).hashValue
    }
}
