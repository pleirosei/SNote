//
//  Note.swift
//  SNote
//
//  Created by Sean Livingston on 2/8/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//

import Foundation

class Note : NSObject, NSCoding {
    var title = ""
    var text = ""
    var date = NSDate()
    
    var shortDate : String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.stringFromDate(date)
    }
    
    override init() {
        super.init()
    }
    
    
    // MARK: - NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(text, forKey: "text")
        aCoder.encodeObject(date, forKey: "date")
    }
    
    required init(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObjectForKey("title") as String
        text = aDecoder.decodeObjectForKey("text") as String
        date = aDecoder.decodeObjectForKey("date") as NSDate
    }
}