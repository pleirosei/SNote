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
    
    private var notes : [Note]!
    
    private init() {
        load()
    }
    
    // MARK: - Crud Methods - Create, Read, Update, Delete
    
    func createNote() -> Note {
        var note = Note()
        notes.append(note)
        return note
    }
    
    func createNote(theNote:Note) {
        notes.append(theNote)
    }
    
    func count() -> Int {
        return notes.count
    }
    
    func getNote(index:Int) -> Note {
        return notes[index]
    }
    
    // update goes here, but not needed since we are passing everything by ref
    
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
    
    func load() {
        let filePath = archiveFilePath()
        let fileManager = NSFileManager.defaultManager()
        
        if fileManager.fileExistsAtPath(filePath) {
            notes = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as [Note]
        } else {
            notes = [Note]()
        }
    }
}

