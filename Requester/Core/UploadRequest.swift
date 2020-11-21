//
//  UploadRequest.swift
//  Requester
//
//  Created by Pavlo Dumyak on 21.11.2020.
//

import Foundation

// TODO: - Still working on

open class File {
    var mimeType: String?
    var fileName: String?
    var filePath: String?
    var file: Data?
}

private class UploadRequest: Request {
    
    private let progress: ((Float) -> Void)?
    private let file: File
    
    public init(owner: ObjectIdentifier,
                url: String,
                file: File,
                requestType: Request.RequestType,
                parameters: [String : Any]? = nil,
                headers: Header? = HTTPHeader(),
                progress: ((Float) -> Void)?,
                onSuccess: @escaping ((Request.SuccessResponse?) -> Void),
                onFail: @escaping ((Request.FailResponse) -> Void)) {
        self.file = file
        self.progress = progress
        super.init(owner: owner,
                   url: url,
                   requestType: requestType,
                   onSuccess: onSuccess, onFail: onFail)
    }

    override func buildURLRequest() -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: url!)!)
        urlRequest.httpMethod = requestType?.rawValue
        let filename = file.fileName ?? ""
        let boundary = UUID().uuidString
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        if let unwrappedParameters = parameters {
            unwrappedParameters.forEach({ (key, value) in
                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                data.append("\(value)".data(using: .utf8)!)
            })
        }
        
        if let fileData = file.file {
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data;filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: \(file.mimeType ?? "")\r\n\r\n".data(using: .utf8)!)
            data.append(fileData)
        }
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        return urlRequest
    }
}
