//
//  ATVResponse.swift
//  AstroTV
//
//  Created by Hung Nguyen Thanh on 10/3/17.
//  Copyright © 2017 Hung Nguyen Thanh. All rights reserved.
//

import UIKit

class ATVResponse: ATVBaseEntity {

    public var responseMessage: String?
    public var responseCode: Int?
    
    required init(json: JSON) {
        
        super.init(json: json)
        
        self.responseMessage = json["responseMessage"].string
        self.responseCode = json["responseCode"].int
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    
}
