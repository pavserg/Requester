//
//  ExecutiveDownloadRequestHandler.swift
//  Requesto
//
//  Created by Pavlo Dumyak on 21.11.2020.
//

import UIKit

class ExecutiveDownloadRequestHandler: RequestHandler {
    
    private let semaphore = DispatchSemaphore.init(value: 0)
    private var progress: ((Float) -> Void)?
    private var completion: ((Request.DownloadSuccessResponse?) -> Void)?
    
    override func processDownloadRequest(request: DownloadRequest, error: Error?) {
        let serviceRequest = request.buildURLRequest()
        progress = request.progress
        completion = request.onDownloadSuccess
        let config = URLSessionConfiguration.background(withIdentifier: UUID().uuidString)
        let session = URLSession(configuration: config, delegate: self, delegateQueue: .none)
        let task = session.downloadTask(with: serviceRequest)
        task.resume()
        if semaphore.wait(timeout: DispatchTime.distantFuture) == .timedOut {}
        super.processDownloadRequest(request: request, error: error)
    }
    
    override func reportRequest(request: Request, error: Error?) {
        super.reportRequest(request: request, error: error)
    }
}

extension ExecutiveDownloadRequestHandler: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        completion?(Request.DownloadSuccessResponse(location: location))
        semaphore.signal()
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progress?(Float(totalBytesWritten/totalBytesExpectedToWrite))
    }
}
