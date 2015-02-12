//
//  NotesTableViewController.swift
//  SNote
//
//  Created by Sean Livingston on 2/8/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    let noteStore = NoteStore.shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var nicole = Note()
//        nicole.title = "Nicole"
//        nicole.text = "My lovely wife."
//        
//        var joanna = Note()
//        joanna.title = "Joanna"
//        joanna.text = "My lovely daughter"
//        
//        var adoniah = Note()
//        adoniah.title = "Adoniah"
//        adoniah.text = "My wonderful son"
//        
//        // add notes to the array
//        noteStore.createNote(nicole)
//        noteStore.createNote(joanna)
//        noteStore.createNote(adoniah)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return noteStore.count()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as NoteTableViewCell
        
        // Configure the cell...
        let rowNumber = indexPath.row
        let theNote = noteStore.getNote(rowNumber)
        
        cell.setupCell(theNote)
        
        //        cell.textLabel?.text = theNote.title
        
        
        
        
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
        noteStore.delete(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        
        let noteDetailViewController = segue.destinationViewController as NoteDetailViewController
        
        // Pass the selected object to the new view controller.
        
        if let indexPath = tableView.indexPathForSelectedRow() {
            
            let rowNumber = indexPath.row
            let theNote = noteStore.getNote(rowNumber)
            
            noteDetailViewController.theNote = theNote
        }
    }
    
    @IBAction func saveNote(segue:UIStoryboardSegue) {
        
        if let indexPath = tableView.indexPathForSelectedRow() {
            // Must be editing a row
            
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        } else {
            // Must be adding a row
            let noteDetailViewController = segue.sourceViewController as NoteDetailViewController
            
            let theNote = noteDetailViewController.theNote
            
            // save the note
            noteStore.createNote(theNote)
            
            // update the screen
            var alert = UIAlertController(title: "Alert", message: "Note Saved", preferredStyle: UIAlertControllerStyle.Alert)
            
            let lastRow = NSIndexPath(forRow: noteStore.count() - 1, inSection: 0)
            tableView.insertRowsAtIndexPaths([lastRow], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
    }
    
}
