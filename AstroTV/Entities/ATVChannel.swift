//
//  ATVChannel.swift
//
//  Created by Hung Nguyen Thanh on 10/2/17
//  Copyright (c) 2017 Hung Nguyen Thanh. All rights reserved.
//

import Foundation

public class ATVChannel: ATVBaseEntity {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let channelCategory = "channelCategory"
        static let siChannelId = "siChannelId"
        static let channelLanguage = "channelLanguage"
        static let channelHD = "channelHD"
        static let channelDescription = "channelDescription"
        static let channelExtRef = "channelExtRef"
        static let channelTitle = "channelTitle"
        static let hdSimulcastChannel = "hdSimulcastChannel"
        static let linearOttMapping = "linearOttMapping"
        static let channelStbNumber = "channelStbNumber"
        static let channelId = "channelId"
    }
    
    // MARK: Properties
    public var channelCategory: String?
    public var siChannelId: String?
    public var channelLanguage: String?
    public var channelHD: Bool? = false
    public var channelDescription: String?
    public var channelExtRef: [ATVChannelExtRef]?
    public var channelTitle: String?
    public var hdSimulcastChannel: Int?
    public var linearOttMapping: [ATVLinearOttMapping]?
    public var channelStbNumber: String?
    public var channelId: Int?
    public var currentEvent: ATVEvent?
    
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
        channelCategory = json[SerializationKeys.channelCategory].string
        siChannelId = json[SerializationKeys.siChannelId].string
        channelLanguage = json[SerializationKeys.channelLanguage].string
        channelHD = json[SerializationKeys.channelHD].boolValue
        channelDescription = json[SerializationKeys.channelDescription].string
        if let items = json[SerializationKeys.channelExtRef].array { channelExtRef = items.map { ATVChannelExtRef(json: $0) } }
        channelTitle = json[SerializationKeys.channelTitle].string
        hdSimulcastChannel = json[SerializationKeys.hdSimulcastChannel].int
        if let items = json[SerializationKeys.linearOttMapping].array { linearOttMapping = items.map { ATVLinearOttMapping(json: $0) } }
        channelStbNumber = json[SerializationKeys.channelStbNumber].string
        channelId = json[SerializationKeys.channelId].int
        
        super.init(json: json)
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = channelCategory { dictionary[SerializationKeys.channelCategory] = value }
        if let value = siChannelId { dictionary[SerializationKeys.siChannelId] = value }
        if let value = channelLanguage { dictionary[SerializationKeys.channelLanguage] = value }
        dictionary[SerializationKeys.channelHD] = channelHD
        if let value = channelDescription { dictionary[SerializationKeys.channelDescription] = value }
        if let value = channelExtRef { dictionary[SerializationKeys.channelExtRef] = value.map { $0.dictionaryRepresentation() } }
        if let value = channelTitle { dictionary[SerializationKeys.channelTitle] = value }
        if let value = hdSimulcastChannel { dictionary[SerializationKeys.hdSimulcastChannel] = value }
        if let value = linearOttMapping { dictionary[SerializationKeys.linearOttMapping] = value.map { $0.dictionaryRepresentation() } }
        if let value = channelStbNumber { dictionary[SerializationKeys.channelStbNumber] = value }
        if let value = channelId { dictionary[SerializationKeys.channelId] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.channelCategory = aDecoder.decodeObject(forKey: SerializationKeys.channelCategory) as? String
        self.siChannelId = aDecoder.decodeObject(forKey: SerializationKeys.siChannelId) as? String
        self.channelLanguage = aDecoder.decodeObject(forKey: SerializationKeys.channelLanguage) as? String
        self.channelHD = aDecoder.decodeBool(forKey: SerializationKeys.channelHD)
        self.channelDescription = aDecoder.decodeObject(forKey: SerializationKeys.channelDescription) as? String
        self.channelExtRef = aDecoder.decodeObject(forKey: SerializationKeys.channelExtRef) as? [ATVChannelExtRef]
        self.channelTitle = aDecoder.decodeObject(forKey: SerializationKeys.channelTitle) as? String
        self.hdSimulcastChannel = aDecoder.decodeObject(forKey: SerializationKeys.hdSimulcastChannel) as? Int
        self.linearOttMapping = aDecoder.decodeObject(forKey: SerializationKeys.linearOttMapping) as? [ATVLinearOttMapping]
        self.channelStbNumber = aDecoder.decodeObject(forKey: SerializationKeys.channelStbNumber) as? String
        self.channelId = aDecoder.decodeObject(forKey: SerializationKeys.channelId) as? Int
        
        super.init(coder: aDecoder)
    }
    
    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(channelCategory, forKey: SerializationKeys.channelCategory)
        aCoder.encode(siChannelId, forKey: SerializationKeys.siChannelId)
        aCoder.encode(channelLanguage, forKey: SerializationKeys.channelLanguage)
        aCoder.encode(channelHD, forKey: SerializationKeys.channelHD)
        aCoder.encode(channelDescription, forKey: SerializationKeys.channelDescription)
        aCoder.encode(channelExtRef, forKey: SerializationKeys.channelExtRef)
        aCoder.encode(channelTitle, forKey: SerializationKeys.channelTitle)
        aCoder.encode(hdSimulcastChannel, forKey: SerializationKeys.hdSimulcastChannel)
        aCoder.encode(linearOttMapping, forKey: SerializationKeys.linearOttMapping)
        aCoder.encode(channelStbNumber, forKey: SerializationKeys.channelStbNumber)
        aCoder.encode(channelId, forKey: SerializationKeys.channelId)
    }
    
    func needUpdateEvent() -> Bool {
        
        if let event = self.currentEvent {
            
            let durations: [Int] = event.displayDuration!.split(separator: Character(":")).map({ Int($0)! })
            let duration: Int = (durations[0] * Duration.hour.rawValue) + (durations[1] * Duration.minute.rawValue) + durations[2]
            if let displayDateTime = event.displayDateTime, var eventTime = Date.fromString(displayDateTime, format: kEventDateFormat) {
                
                print(eventTime.toString())
                eventTime.addTimeInterval(TimeInterval(duration))
                print(eventTime.toString())
                
                if eventTime.compare(Date()) == .orderedDescending {
                    
                    return false
                }
            }
            
        }
        
        return true
    }
    
}
