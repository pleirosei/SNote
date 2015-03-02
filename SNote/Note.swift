//
//  Note.swift
//  SNote
//
//  Created by Sean Livingston on 2/8/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//

import Foundation

class Note : PFObject, PFSubclassing {
    
    override class func load() {
        self.registerSubclass()
    }
    class func parseClassName() -> String! {
        return "Note"
    }
    
    override init() {
        super.init()
    }
    
    var title : String? {
        get { return objectForKey("title") as String? }
        set { setObject(newValue, forKey: "title") }
    }
    
    var text : String? {
        get { return objectForKey("noteBody") as String? }
        set { setObject(newValue, forKey: "noteBody") }
    }
    
}