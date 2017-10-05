//
//  ATVNetworkUtils.swift
//  AstroTV
//
//  Created by Hung Nguyen Thanh on 10/2/17.
//  Copyright © 2017 Hung Nguyen Thanh. All rights reserved.
//

import UIKit
import AWSS3

class ATVNetworkUtils: NSObject {

    static let sharedInstance = ATVNetworkUtils()
    
    private var networkOperationQueue: OperationQueue
    private var networkSession: URLSession!
    let transferManager = AWSS3TransferManager.default()
    
    var tasks = [URLSessionDataTask]()
    
    override init() {
        
        self.networkOperationQueue = OperationQueue()
        self.networkOperationQueue.name = "Network Operation Queue"
        
        super.init()
        
        self.networkSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: self.networkOperationQueue)
    }
    
    private func getSendHeader(with headers: [String: String]?) -> [String: String] {
        
        var sentHeaders = headers
        if sentHeaders == nil {
            
            sentHeaders = [String: String]()
        }
        
        return sentHeaders!
    }
    
    func request(api: API, method: HTTPMethod = .get, parameters: [String : String]? = nil, headers: [String : String]? = nil, completionHandler: @escaping (_ response: ATVResponse?, _ code: HTTPCode) -> Void) {
        
        var urlComponents = api.urlComponents
        var queryItems = [URLQueryItem]()
        parameters?.forEach({
            
            queryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        })
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            
            completionHandler(nil, .badRequest)
            return
        }
        
        var request = URLRequest(url: url)
        
        headers?.forEach({
            
            request.addValue($0.key, forHTTPHeaderField: $0.value)
        })
        
        var dataTask: URLSessionDataTask? = nil
        dataTask = self.networkSession.dataTask(with: request) { (data, response, error) in
            
            defer {
                
                if let dataTask = dataTask, let index = self.tasks.index(of: dataTask) {
                    
                    self.tasks.remove(at: index)
                }
            }
            
            let dataResponse: ATVResponse?
            if let data = data {
                
                dataResponse = ATVResponse(json: JSON(with: data))
            } else {
                
                dataResponse = nil
            }
            
            var httpCode: HTTPCode
            if let response = response as? HTTPURLResponse, let code = HTTPCode(rawValue: response.statusCode) {
                
                httpCode = code
            } else {
                
                httpCode = HTTPCode.badRequest
            }
            
            DispatchQueue.main.async {
                
                completionHandler(dataResponse, httpCode)
            }
            
        }
        
        if let dataTask = dataTask {
            
            self.tasks.append(dataTask)
            dataTask.resume()
        }
    }
    
    func downloadImage(with url: URL, completeHandler: @escaping (_ image: UIImage?) -> Void) {
        
        var request = URLRequest(url: url)
        
        var dataTask: URLSessionDataTask? = nil
        dataTask = self.networkSession.dataTask(with: request) { (data, response, error) in
            
            defer {
                
                objc_sync_enter(self.tasks)
                
                if let dataTask = dataTask, let index = self.tasks.index(of: dataTask) {
                    
                    self.tasks.remove(at: index)
                }
                
                objc_sync_exit(self.tasks)
            }
            
            if let data = data, let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    
                    completeHandler(image)
                }
            }
            
        }
        
        if let dataTask = dataTask {
            
            self.tasks.append(dataTask)
            dataTask.resume()
        }
    }
    
    func getEvent(forChannel channel: ATVChannel, completionHandler: @escaping (_ event: ATVEvent?) -> Void) {
        
        let dateNowString = Date().toString(with: kDateWithOnlyHourFormat)
        var currentDate = Date.fromString(dateNowString, format: kDateWithOnlyHourFormat)!
        currentDate.addTimeInterval(TimeInterval(0 - (5 * Duration.minute.rawValue)))
        var params = [String: String]()
        params["channelId"] = String(channel.channelId!)
        params["periodStart"] = currentDate.toString(with: kDateFormat)
        currentDate.addTimeInterval(TimeInterval(65 * Duration.minute.rawValue))
        params["periodEnd"] = currentDate.toString(with: kDateFormat)
        
        self.request(api: API.getEvents, parameters: params, completionHandler: { (response, code) in
            
            if let response = response {
                
                if let responseCode = response.responseCode, let code = HTTPCode(rawValue: responseCode), code == .success {
                    
                    if let events: [ATVEvent] = response.nestedObjectArray(arrayName: "getevent"), let event = events.last {
                        
                        channel.currentEvent = event
                        completionHandler(event)
                        
                    }
                    
                }
                
            }
        })
    }
    
    func s3DownloadFile(_ fileName: String, filePath: String, completionHandler:@escaping (_ result: AnyObject?) -> Void) {
        
        let downloadingFileURL = URL(fileURLWithPath: filePath)
        
        if let downloadRequest = AWSS3TransferManagerDownloadRequest() {
        
            downloadRequest.bucket = "astrotv"
            downloadRequest.key = fileName
            downloadRequest.downloadingFileURL = downloadingFileURL
            
            transferManager.download(downloadRequest).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
                
                if let error = task.error as NSError? {
                    if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                        switch code {
                        case .cancelled, .paused:
                            break
                        default:
                            print("Error downloading: \(String(describing: downloadRequest.key)) Error: \(error)")
                        }
                    } else {
                        print("Error downloading: \(String(describing: downloadRequest.key)) Error: \(error)")
                    }
                    
                    completionHandler(nil)
                    return nil
                }
                
                print("Download complete for: \(String(describing: downloadRequest.key))")
                let downloadOutput = task.result
                completionHandler(downloadOutput)
                
                return nil
            })
            
        }
    }
    
    func s3UploadFile(_ fileName: String, filePath: String, completionHandler:@escaping (_ result: AnyObject?) -> Void) {
        
        let uploadingFileURL = URL(fileURLWithPath: filePath)
        
        if let uploadRequest = AWSS3TransferManagerUploadRequest() {
            
            uploadRequest.bucket = "astrotv"
            uploadRequest.key = fileName
            uploadRequest.body = uploadingFileURL
            uploadRequest
            
            transferManager.upload(uploadRequest).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
                
                if let error = task.error as? NSError {
                    if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                        switch code {
                        case .cancelled, .paused:
                            break
                        default:
                            print("Error uploading: \(uploadRequest.key) Error: \(error)")
                        }
                    } else {
                        print("Error uploading: \(uploadRequest.key) Error: \(error)")
                    }
                    
                    completionHandler(nil)
                    return nil
                }
                
                let uploadOutput = task.result
                print("Upload complete for: \(uploadRequest.key)")
                
                completionHandler(uploadOutput)
                return nil
            })
        }
    }
    
}

extension ATVNetworkUtils: URLSessionDelegate {
    
    
}
