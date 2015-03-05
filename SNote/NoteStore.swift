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
    
    private var notes: [AnyObject]! = [AnyObject]()
    
    private init() {
    }
    
    // MARK: - Crud Methods - Create, Read, Update, Delete
    
    // "completeion" portion makes TableView reload after background data loads
    
    func fetchAllObjects(completion:(()->())?) {
        var query = PFQuery(className: "Note")
        query.whereKeyExists("objectId")
        query.includeKey("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                println("Successfully retrieved \(objects.count) results")
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var index: Int = 0
                        
                        self.notes.append(object)
                        println("\(self.notes[index])")
                        ++index
                    }
                }
                
                completion?()
                
            }
        }
    
    }
    
    
    func createNote() -> Note {
        var note = Note()
        note.save()
        notes.append(note)
        return note
    }

    func createNote(theNote:Note) {
        notes.append(theNote)
        theNote.saveInBackgroundWithBlock(nil)
    }
    
    func count() -> Int {
        return notes.count
    }
    
    func getNote(index:Int) -> Note {
        return notes[index] as Note
    }
    
    // update goes here, but not needed since we are passing everything by ref
    
    func updateNote(index:Int) {
        var theNote: Note
        var temp: Note = notes[index] as Note
        theNote = temp
        theNote.saveInBackgroundWithBlock(nil)
        return notes[index] = theNote
    }
    
    func delete(index:Int) {
        notes.removeAtIndex(index)
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
}

