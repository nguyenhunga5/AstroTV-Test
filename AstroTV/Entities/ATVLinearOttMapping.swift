//
//  ATVLinearOttMapping.swift
//
//  Created by Hung Nguyen Thanh on 10/2/17
//  Copyright (c) 2017 Hung Nguyen Thanh. All rights reserved.
//

import Foundation

public class ATVLinearOttMapping: ATVBaseEntity {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let platform = "platform"
    }
    
    // MARK: Properties
    public var platform: String?
    
    // MARK: JSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from JSON.
    public required init(json: JSON) {
        platform = json[SerializationKeys.platform].string
        
        super.init(json: json)
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = platform { dictionary[SerializationKeys.platform] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.platform = aDecoder.decodeObject(forKey: SerializationKeys.platform) as? String
        
        super.init(coder: aDecoder)
    }
    
    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(platform, forKey: SerializationKeys.platform)
    }
    
}
