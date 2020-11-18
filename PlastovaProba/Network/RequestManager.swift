//
//  RequestManager.swift
//  PlastovaProba
//
//  Created by Pavlo Dumyak on 18.11.2020.
//  Copyright © 2020 Pavlo Dumyak. All rights reserved.
//


import UIKit
import Firebase

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class RequestManager: NSObject {
    
    fileprivate var params: [String:AnyObject]?
    fileprivate let url: String?
    fileprivate var requestType: String?
    
    var onFail: ((_ error: NSError?) -> Void)?
    var onSuccess: ((_ object: AnyObject, _ parsedObject: Any?) -> Void)?
    
    init(url: String, params: [String: AnyObject]?, requestType: HTTPMethod) {
        self.params = (params ?? [:])
        self.url = url
        self.requestType = requestType.rawValue
    }
    
    func doRequest<T: Decodable>(responseType type: T.Type) {
        sendHttpRequest(responceType: type)
    }
    
    func sendHttpRequest<T:Decodable>(responceType type: T.Type) {
        guard let urlString = url else {
            return
        }
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Token.accessToken)", forHTTPHeaderField: "Authorization")
      
        if let unwrappedParameters = self.params {
            let jsonData = try? JSONSerialization.data(withJSONObject: unwrappedParameters)
            request.httpBody = jsonData
        }
        
        request.httpMethod = requestType
        let session = URLSession.shared
        session.dataTask(with: request) {data, response, error in
            if error == nil {
                self.parseObject(data as AnyObject, objectType: type)
            } else {
                self.onFail?(error as NSError?)
            }
            }.resume()
    }
    
    fileprivate func parseObject<T: Decodable>(_ object: AnyObject, objectType: T.Type) {
        if let unwrappedData = object as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                let model = try jsonDecoder.decode(objectType, from: unwrappedData)
                self.onSuccess?(object, model as Any?)
            } catch {
                self.onSuccess?(object, nil)
            }
        }
    }
}
