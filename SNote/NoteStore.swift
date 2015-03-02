//
//  NoteStore.swift
//  SNote
//
//  Created by Sean Livingston on 2/9/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//

import Foundation

class NoteStore {
    // MARK: Singleton Pattern
    private struct Static {
        static let instance : NoteStore = NoteStore()
    }
    class func shared() -> NoteStore {
        return Static.instance
    }
    
    private var notes : NSMutableArray! = NSMutableArray()
    
    private init() {
        load()
    }
    
    // MARK: - Crud Methods - Create, Read, Update, Delete
    
    
    func fetchAllObjects() {
        var query : PFQuery = PFQuery(className: "Note")
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                
                self.fetchAllObjects()
                
            } else {
                println(error.description)
            }
        }
    }
    
    
    func createNote() -> Note {
        var note = Note()
        note.save()
        return note
    }

    func createNote(theNote:Note) {
        theNote.save()
    }
    
    func count() -> Int {
        return notes.count
    }
    
    func getNote(index:Int) -> Note {
        return notes[index] as Note
    }
    
    // update goes here, but not needed since we are passing everything by ref
    
    func delete(index:Int) {
        notes.removeObjectAtIndex(index)
    }
    
    // Mark: - Persistence
    
    private func archiveFilePath() -> String {
        //Temporary directory
//        NSTemporaryDirectory()
        
        // Documents directory
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as NSString
        let path = documentsDirectory.stringByAppendingPathComponent("NoteStore.plist")
        
        return path
    }
    
    func save() {
        NSKeyedArchiver.archiveRootObject(notes, toFile: archiveFilePath())
    }
    
    func load() -> PFQuery! {
        var query = Note.query()
        
        return query
    }
}

