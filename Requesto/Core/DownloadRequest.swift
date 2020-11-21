//
//  DownloadRequest.swift
//  Requesto
//
//  Created by Pavlo Dumyak on 21.11.2020.
//

import Foundation

public class DownloadRequest: Request {
    
    let progress: ((Float) -> Void)?
    let onDownloadSuccess: ((Request.DownloadSuccessResponse?) -> Void)?
    
    public init(owner: ObjectIdentifier,
                url: String,
                requestType: Request.RequestType,
                parameters: [String : Any]? = nil,
                headers: Header? = HTTPHeader(),
                progress: ((Float) -> Void)?,
                onDownloadSuccess: @escaping ((Request.DownloadSuccessResponse?) -> Void),
                onFail: @escaping ((Request.FailResponse) -> Void)) {
        
        self.progress = progress
        self.onDownloadSuccess = onDownloadSuccess
        super.init(owner: owner,
                   url: url,
                   requestType: requestType,
                   onSuccess: nil, onFail: onFail)
    }

    override func buildURLRequest() -> URLRequest {
        super.buildURLRequest()
    }
    
    @available(*, unavailable, message:"DownloadRequest can't executeSync with parameters")
    override public func executeSync<T>(parseAs: T.Type) where T : Decodable {}
    
    @available(*, unavailable, message:"DownloadRequest can't executeSync with parameters")
    override public func executeAsync<T>(parseAs: T.Type) where T : Decodable {}
    
    public func executeSync() {
        Requester.shared.processDownloadRequest(request: self)
    }
}
