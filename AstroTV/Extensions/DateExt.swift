//
//  DateExt.swift
//  AstroTV
//
//  Created by Hung Nguyen Thanh on 10/3/17.
//  Copyright © 2017 Hung Nguyen Thanh. All rights reserved.
//

import Foundation

extension Date {
    
    func localToUTC() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = kDateFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = kDateFormat
        
        return dateFormatter.string(from: self)
    }
    
    static func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = kDateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = kDateFormat
        
        return dateFormatter.string(from: dt!)
    }
    
    func toString(with format: String = kEventDisplayFormat) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = kDateFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    static func fromString(_ string: String, format: String = kDateFormat) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = kDateFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: string)
    }
}
