//
//  ATVDefinitions.swift
//  AstroTV
//
//  Created by Hung Nguyen Thanh on 10/2/17.
//  Copyright © 2017 Hung Nguyen Thanh. All rights reserved.
//

import UIKit

public typealias JSON = ATVJSON
typealias ATVAlertHandlerClosue = (_ buttonIndex: Int)-> Void

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public enum HTTPCode: Int {
    
    case success            = 200
    case badRequest         = 400
    case unauthorized       = 401
    case forbidden          = 403
    case notfound           = 404
    case methodNotAllow     = 405
    case genericServerError = 500
    
}

public enum API: String {
    
    private static let base = "http://ams-api.astro.com.my/ams/v3/"
    
    case getChannelList = "getChannelList"
    case getChannels = "getChannels"
    case getEvents = "getEvents"
    case searchEvents = "searchEvents"
    case getVOD = "getVOD"
    case searchVOD = "searchVOD"
    case getContent = "epg/getContent"
    case getBucketList = "getBucketList"
    case getCuratedContentLite = "epg/getCuratedContentLite"
    
    var urlComponents: URLComponents {
        
        return URLComponents(string: API.base + self.rawValue)!
    }
}

let kDateFormat = "yyyy-MM-dd HH:mm"
let kDateWithOnlyHourFormat = "yyyy-MM-dd HH"
let kEventDateFormat = "yyyy-MM-dd HH:mm:ss.S"
let kEventDisplayFormat = "HH:mm a"
let kChannelHeight = CGFloat(100)
let kShowListSegue = "showListSegue"
let kIdentityPoolId = "ap-southeast-1:8b7bdb20-3a5b-40c3-a16f-fb30aea44e35"
let kSortMode = "kSortMode"
let kSortAsc  = "kSortAsc"

public enum Duration: Int {
    
    case hour = 3600
    case minute = 60
}

class ATVDefinitions: NSObject {

}
