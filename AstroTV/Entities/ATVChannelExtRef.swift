//
//  ATVChannelExtRef.swift
//
//  Created by Hung Nguyen Thanh on 10/2/17
//  Copyright (c) 2017 Hung Nguyen Thanh. All rights reserved.
//

import Foundation

public class ATVChannelExtRef: ATVBaseEntity {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let system = "system"
        static let subSystem = "subSystem"
        static let value = "value"
    }
    
    // MARK: Properties
    public var system: String?
    public var subSystem: String?
    public var value: String?
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public required init(json: JSON) {
        system = json[SerializationKeys.system].string
        subSystem = json[SerializationKeys.subSystem].string
        value = json[SerializationKeys.value].string
        
        super.init(json: json)
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = system { dictionary[SerializationKeys.system] = value }
        if let value = subSystem { dictionary[SerializationKeys.subSystem] = value }
        if let value = value { dictionary[SerializationKeys.value] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.system = aDecoder.decodeObject(forKey: SerializationKeys.system) as? String
        self.subSystem = aDecoder.decodeObject(forKey: SerializationKeys.subSystem) as? String
        self.value = aDecoder.decodeObject(forKey: SerializationKeys.value) as? String
        
        super.init(coder: aDecoder)
    }
    
    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(system, forKey: SerializationKeys.system)
        aCoder.encode(subSystem, forKey: SerializationKeys.subSystem)
        aCoder.encode(value, forKey: SerializationKeys.value)
        
    }
    
}
