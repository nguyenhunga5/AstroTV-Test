//
//  ATVBaseEntity.swift
//  AstroTV
//
//  Created by Hung Nguyen Thanh on 10/2/17.
//  Copyright © 2017 Hung Nguyen Thanh. All rights reserved.
//

import UIKit

public class ATVBaseEntity: NSObject, NSCoding {

    public var json: JSON?
    
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from JSON.
    public required init(json: JSON) {
        
        super.init()
        
        self.json = json
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
    }
    
    public func encode(with aCoder: NSCoder) {
        
    }
    
    // MARK: - Support Method
    func nestedObject<T: ATVBaseEntity>(objectName : String) -> T? {
        
        var obj : T?
        if let json = self.json, let jsonObject = json[objectName].object {
            
            obj = T(json: jsonObject)
        }
        
        return obj
    }
    
    func nestedObjectArray<T: ATVBaseEntity>(arrayName : String) -> [T]? {
        
        var obj : [T]?
        if let json = self.json, let jsonArray = json[arrayName].array {
            
            obj = jsonArray.map({
                T(json: $0)
            })
        }
        
        return obj
    }
}
