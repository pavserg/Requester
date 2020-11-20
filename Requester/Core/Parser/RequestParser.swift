//
//  Parser.swift
//  Requester
//
//  Created by Pavlo Dumyak on 20.11.2020.
//

import Foundation

class RequestParser {
    
    enum ParseResult {
        case success
        case successWith(object: AnyObject)
        case failed(error: Error)
    }
    
    enum ParseError: Error {
        case noResponse
        case noObject
    }
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return decoder
    }()
  
    public func parse<T: Decodable>(object: Data?, objectType: T.Type, response: URLResponse?) -> ParseResult {
        guard let response = response, let httpResponse = response as? HTTPURLResponse else { return .failed(error: ParseError.noResponse) }
        do {
            let object = try parseObject(object: object, objectType: objectType)
            return .successWith(object: object)
        } catch {
            if httpResponse.statusCode == 200 {
                return .success
            }
            return .failed(error: error)
        }
    }
    
    private func parseObject<T: Decodable>(object: Data?, objectType: T.Type) throws -> AnyObject {
        if let jsonData = object, !jsonData.isEmpty {
                let result = try decoder.decode(objectType, from: jsonData)
                return result as AnyObject
            } else {
            throw ParseError.noObject
        }
    }
}
