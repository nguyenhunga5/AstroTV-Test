//
//  ATVEvent.swift
//
//  Created by Hung Nguyen Thanh on 10/3/17
//  Copyright (c) 2017 Hung Nguyen Thanh. All rights reserved.
//

import Foundation

public class ATVEvent: ATVBaseEntity {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let channelHD = "channelHD"
        static let premier = "premier"
        static let shortSynopsis = "shortSynopsis"
        static let programmeId = "programmeId"
        static let certification = "certification"
        static let genre = "genre"
        static let displayDateTimeUtc = "displayDateTimeUtc"
        static let directors = "directors"
        static let producers = "producers"
        static let channelStbNumber = "channelStbNumber"
        static let live = "live"
        static let eventID = "eventID"
        static let actors = "actors"
        static let channelTitle = "channelTitle"
        static let siTrafficKey = "siTrafficKey"
        static let subGenre = "subGenre"
        static let ottBlackout = "ottBlackout"
        static let programmeTitle = "programmeTitle"
        static let displayDuration = "displayDuration"
        static let displayDateTime = "displayDateTime"
        static let vernacularData = "vernacularData"
        static let channelId = "channelId"
        static let episodeId = "episodeId"
        static let contentImage = "contentImage"
    }
    
    // MARK: Properties
    public var channelHD: String?
    public var premier: Bool? = false
    public var shortSynopsis: String?
    public var programmeId: String?
    public var certification: String?
    public var genre: String?
    public var displayDateTimeUtc: String?
    public var directors: String?
    public var producers: String?
    public var channelStbNumber: String?
    public var live: Bool? = false
    public var eventID: String?
    public var actors: String?
    public var channelTitle: String?
    public var siTrafficKey: String?
    public var subGenre: String?
    public var ottBlackout: Bool? = false
    public var programmeTitle: String?
    public var displayDuration: String?
    public var displayDateTime: String?
    public var vernacularData: [ATVVernacularData]?
    public var contentImage: [ATVContentImage]?
    public var channelId: Int?
    public var episodeId: String?
    
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
        
        super.init(json: json)
        
        channelHD = json[SerializationKeys.channelHD].string
        premier = json[SerializationKeys.premier].boolValue
        shortSynopsis = json[SerializationKeys.shortSynopsis].string
        programmeId = json[SerializationKeys.programmeId].string
        certification = json[SerializationKeys.certification].string
        genre = json[SerializationKeys.genre].string
        displayDateTimeUtc = json[SerializationKeys.displayDateTimeUtc].string
        directors = json[SerializationKeys.directors].string
        producers = json[SerializationKeys.producers].string
        channelStbNumber = json[SerializationKeys.channelStbNumber].string
        live = json[SerializationKeys.live].boolValue
        eventID = json[SerializationKeys.eventID].string
        actors = json[SerializationKeys.actors].string
        channelTitle = json[SerializationKeys.channelTitle].string
        siTrafficKey = json[SerializationKeys.siTrafficKey].string
        subGenre = json[SerializationKeys.subGenre].string
        ottBlackout = json[SerializationKeys.ottBlackout].boolValue
        programmeTitle = json[SerializationKeys.programmeTitle].string
        displayDuration = json[SerializationKeys.displayDuration].string
        displayDateTime = json[SerializationKeys.displayDateTime].string
        if let items = json[SerializationKeys.vernacularData].array {
            
            vernacularData = items.map { return ATVVernacularData(object: $0) }
            
        }
        channelId = json[SerializationKeys.channelId].int
        episodeId = json[SerializationKeys.episodeId].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = channelHD { dictionary[SerializationKeys.channelHD] = value }
        dictionary[SerializationKeys.premier] = premier
        if let value = shortSynopsis { dictionary[SerializationKeys.shortSynopsis] = value }
        if let value = programmeId { dictionary[SerializationKeys.programmeId] = value }
        if let value = certification { dictionary[SerializationKeys.certification] = value }
        if let value = genre { dictionary[SerializationKeys.genre] = value }
        if let value = displayDateTimeUtc { dictionary[SerializationKeys.displayDateTimeUtc] = value }
        if let value = directors { dictionary[SerializationKeys.directors] = value }
        if let value = producers { dictionary[SerializationKeys.producers] = value }
        if let value = channelStbNumber { dictionary[SerializationKeys.channelStbNumber] = value }
        dictionary[SerializationKeys.live] = live
        if let value = eventID { dictionary[SerializationKeys.eventID] = value }
        if let value = actors { dictionary[SerializationKeys.actors] = value }
        if let value = channelTitle { dictionary[SerializationKeys.channelTitle] = value }
        if let value = siTrafficKey { dictionary[SerializationKeys.siTrafficKey] = value }
        if let value = subGenre { dictionary[SerializationKeys.subGenre] = value }
        dictionary[SerializationKeys.ottBlackout] = ottBlackout
        if let value = programmeTitle { dictionary[SerializationKeys.programmeTitle] = value }
        if let value = displayDuration { dictionary[SerializationKeys.displayDuration] = value }
        if let value = displayDateTime { dictionary[SerializationKeys.displayDateTime] = value }
        if let value = vernacularData { dictionary[SerializationKeys.vernacularData] = value }
        if let value = channelId { dictionary[SerializationKeys.channelId] = value }
        if let value = episodeId { dictionary[SerializationKeys.episodeId] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.channelHD = aDecoder.decodeObject(forKey: SerializationKeys.channelHD) as? String
        self.premier = aDecoder.decodeBool(forKey: SerializationKeys.premier)
        self.shortSynopsis = aDecoder.decodeObject(forKey: SerializationKeys.shortSynopsis) as? String
        self.programmeId = aDecoder.decodeObject(forKey: SerializationKeys.programmeId) as? String
        self.certification = aDecoder.decodeObject(forKey: SerializationKeys.certification) as? String
        self.genre = aDecoder.decodeObject(forKey: SerializationKeys.genre) as? String
        self.displayDateTimeUtc = aDecoder.decodeObject(forKey: SerializationKeys.displayDateTimeUtc) as? String
        self.directors = aDecoder.decodeObject(forKey: SerializationKeys.directors) as? String
        self.producers = aDecoder.decodeObject(forKey: SerializationKeys.producers) as? String
        self.channelStbNumber = aDecoder.decodeObject(forKey: SerializationKeys.channelStbNumber) as? String
        self.live = aDecoder.decodeBool(forKey: SerializationKeys.live)
        self.eventID = aDecoder.decodeObject(forKey: SerializationKeys.eventID) as? String
        self.actors = aDecoder.decodeObject(forKey: SerializationKeys.actors) as? String
        self.channelTitle = aDecoder.decodeObject(forKey: SerializationKeys.channelTitle) as? String
        self.siTrafficKey = aDecoder.decodeObject(forKey: SerializationKeys.siTrafficKey) as? String
        self.subGenre = aDecoder.decodeObject(forKey: SerializationKeys.subGenre) as? String
        self.ottBlackout = aDecoder.decodeBool(forKey: SerializationKeys.ottBlackout)
        self.programmeTitle = aDecoder.decodeObject(forKey: SerializationKeys.programmeTitle) as? String
        self.displayDuration = aDecoder.decodeObject(forKey: SerializationKeys.displayDuration) as? String
        self.displayDateTime = aDecoder.decodeObject(forKey: SerializationKeys.displayDateTime) as? String
        self.vernacularData = aDecoder.decodeObject(forKey: SerializationKeys.vernacularData) as? [ATVVernacularData]
        self.contentImage = aDecoder.decodeObject(forKey: SerializationKeys.contentImage) as? [ATVContentImage]
        self.channelId = aDecoder.decodeObject(forKey: SerializationKeys.channelId) as? Int
        self.episodeId = aDecoder.decodeObject(forKey: SerializationKeys.episodeId) as? String
    }
    
    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(channelHD, forKey: SerializationKeys.channelHD)
        aCoder.encode(premier, forKey: SerializationKeys.premier)
        aCoder.encode(shortSynopsis, forKey: SerializationKeys.shortSynopsis)
        aCoder.encode(programmeId, forKey: SerializationKeys.programmeId)
        aCoder.encode(certification, forKey: SerializationKeys.certification)
        aCoder.encode(genre, forKey: SerializationKeys.genre)
        aCoder.encode(displayDateTimeUtc, forKey: SerializationKeys.displayDateTimeUtc)
        aCoder.encode(directors, forKey: SerializationKeys.directors)
        aCoder.encode(producers, forKey: SerializationKeys.producers)
        aCoder.encode(channelStbNumber, forKey: SerializationKeys.channelStbNumber)
        aCoder.encode(live, forKey: SerializationKeys.live)
        aCoder.encode(eventID, forKey: SerializationKeys.eventID)
        aCoder.encode(actors, forKey: SerializationKeys.actors)
        aCoder.encode(channelTitle, forKey: SerializationKeys.channelTitle)
        aCoder.encode(siTrafficKey, forKey: SerializationKeys.siTrafficKey)
        aCoder.encode(subGenre, forKey: SerializationKeys.subGenre)
        aCoder.encode(ottBlackout, forKey: SerializationKeys.ottBlackout)
        aCoder.encode(programmeTitle, forKey: SerializationKeys.programmeTitle)
        aCoder.encode(displayDuration, forKey: SerializationKeys.displayDuration)
        aCoder.encode(displayDateTime, forKey: SerializationKeys.displayDateTime)
        aCoder.encode(vernacularData, forKey: SerializationKeys.vernacularData)
        aCoder.encode(channelId, forKey: SerializationKeys.channelId)
        aCoder.encode(episodeId, forKey: SerializationKeys.episodeId)
    }
    
}
