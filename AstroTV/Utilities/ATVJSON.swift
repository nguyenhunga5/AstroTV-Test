//
//  ATVJSON.swift
//  AstroTV
//
//  Created by Hung Nguyen Thanh on 10/2/17.
//  Copyright © 2017 Hung Nguyen Thanh. All rights reserved.
//

import UIKit

public class ATVJSONValue: NSObject {
    
    var value: AnyObject?
    
    var string: String? {
        
        set {
            
            self.value = newValue as AnyObject
        }
        
        get {
            
            return self.value != nil ? self.value!.description : nil
        }
    }
    
    var int: Int? {
        
        set {
            
            self.value = newValue as AnyObject
        }
        
        get {
            
            if let str = self.string {
                
                return Int(str)
            } else {
                
                return nil
            }
        }
    }
    
    var boolValue: Bool? {
        
        set {
            
            self.value = newValue as AnyObject
        }
        
        get {
            
            if let str = self.string {
                
                return Bool(str)
            } else {
                
                return nil
            }
        }
    }
    
    var float: Float? {
        
        set {
            
            self.value = newValue as AnyObject
        }
        
        get {
            
            if let str = self.string {
                
                return Float(str)
            } else {
                
                return nil
            }
        }
    }
    
    var double: Double? {
        
        set {
            
            self.value = newValue as AnyObject
        }
        
        get {
            
            if let str = self.string {
                
                return Double(str)
            } else {
                
                return nil
            }
        }
    }
    
    var array: [ATVJSON]? {
        
        set {
            
            self.value = newValue as AnyObject
        }
        
        get {
            
            if let array = self.value as? [ATVJSON] {
                
                return array
            } else if let arrayObj = self.value as? [[String: AnyObject]] {
                
                let array: [ATVJSON] = arrayObj.map({
                    
                    ATVJSON($0)
                })
                
                return array
            } else {
                
                return nil
            }
        }
    }
    
    var object: ATVJSON? {
        
        set {
            
            self.value = newValue as AnyObject
        }
        
        get {
            
            if let obj = self.value as? ATVJSON {
                
                return obj
            } else {
                
                return nil
            }
        }
    }
    
    init(value: AnyObject?) {
        
        self.value = value
        super.init()
    }
}

public class ATVJSON: NSObject {

    var json = [String: ATVJSONValue]()
    
    init(_ object: Any) {
        
        super.init()
        
        self.parser(object)
    }
    
    init(with data: Data) {
        
        super.init()
        
        do {
            
            let obj = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            self.parser(obj)
            
        } catch {
            
            print("\(error)\n")
        }
        
    }
    
    func parser(_ object: Any) {
        
        if let obj = object as? [String: AnyObject] {
            
            obj.forEach({
                
                self.json[$0.key] = ATVJSONValue(value: $0.value)
            })
        }
    }
    
    subscript(key : String) -> ATVJSONValue {
        
        get {
            
            return json[key] ?? ATVJSONValue(value: nil)
        }
        
        set {
            
            json[key] = newValue
        }
    }
}
