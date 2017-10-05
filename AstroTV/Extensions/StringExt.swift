//
//  StringExt.swift
//  AstroTV
//
//  Created by Hung Nguyen Thanh on 10/2/17.
//  Copyright © 2017 Hung Nguyen Thanh. All rights reserved.
//

import Foundation

extension String {
    
    var urlEncode: String {
        
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
    }
    
    var urlDecode: String {
        
        return self.removingPercentEncoding!
        
    }
    
    // MARK: - Validate String
    // MARK: - trimString
    func trimString() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    // MARK: - isEmptyString
    func isEmptyString() -> Bool{
        if self.trimString().isEmpty {
            return true
        }
        return false
    }
    
    
    // MARK: - String path component helper
    var lastPathComponent: String {
        
        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
        
        get {
            
            return (self as NSString).pathExtension
        }
    }
    var stringByDeletingLastPathComponent: String {
        
        get {
            
            return (self as NSString).deletingLastPathComponent
        }
    }
    var stringByDeletingPathExtension: String {
        
        get {
            
            return (self as NSString).deletingPathExtension
        }
    }
    var pathComponents: [String] {
        
        get {
            
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(ext: String) -> String? {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathExtension(ext)
    }
    
    var length: Int {
        get {
            return self.characters.count
        }
    }
    
    func filterOnlyNumber() -> String {
        
        let nStr = String(self.characters.filter { (char: Character) -> Bool in
            char >= "0" && char <= "9"
        })
        
        return nStr
    }
}
