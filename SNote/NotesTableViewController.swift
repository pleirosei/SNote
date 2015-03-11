//
//  NotesTableViewController.swift
//  SNote
//
//  Created by Sean Livingston on 2/8/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//

import UIKit

class NotesTableViewController: PFQueryTableViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = Note().parseClassName
    }
    

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var noteStore = NoteStore.shared()
    
    
    var searchText = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        loadNotes()
    }
    
 
    
    
    // MARK: - Table view data source
    

   
    
    
    
    
    
    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        
//        return 12
//    }
    
    func loadNotes() {
        // Causes the Tableview to load after fetching data in background
        
        self.noteStore.fetchAllObjects { () -> () in
            self.tableView.reloadData()
        }
    }
    
    private class SectionData {
        var month = 0
        var year = 0
        var rows = [Note]()
        init(month:Int, year:Int) {
            self.month = month
            self.year = year
        }
    }
    
    private var sections = [SectionData]()

 
    override func objectsDidLoad(error: NSError!) {
        
       
        
        sectionTheData()
        
        super.objectsDidLoad(error)
        
    }
    
    
    func sectionTheData() {
        
        
        
        var counter = Int()
        counter++
        println(counter)
        
        var lastMonth = 0
        var lastYear = 0
        var currentSection : SectionData!
        sections.removeAll(keepCapacity: true)

        
        println(self.objects.count)
    
        for object in self.objects {
            if let theDate = object.createdAt {
                // Break createdAt date into it's fundamental components
                let components = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.YearCalendarUnit, fromDate: theDate)
                // Everytime we encounter a new month/year combination....
                if lastMonth != components.month || lastYear != components.year {
                    // Tada, found a new section!!!!
                    
                    // Create a placeholder for that section
                    currentSection = SectionData(month:components.month, year:components.year)
                    // Add it to our total sections
                    sections.append(currentSection)
                    // watch for next section change
                    lastMonth = components.month
                    lastYear = components.year
                }
                // add the current note to the current section
                currentSection.rows.append(object as Note)
            }
        }
        
    }
    
    override func objectAtIndexPath(indexPath: NSIndexPath!) -> PFObject! {
        
        return sections[indexPath.section].rows[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sections.count == 0  { return "" }
        let sectionData = sections[section]
        
        return "\(sectionData.month) - \(sectionData.year)"
    }
    
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as NoteTableViewCell
        
        
        

        
        // Configure the cell...
        let rowNumber = indexPath.row
        let theNote = object as Note
        
        cell.setupCell(theNote)
        
        
        
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
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            noteStore.delete(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        }
//    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            var object: PFObject = self.objects[indexPath.row] as PFObject
            object.deleteInBackgroundWithBlock({ (succeded, error) -> Void in
            self.loadObjects()
            })
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
            
            var object: PFObject = self.objects[indexPath.row] as PFObject
            object.saveInBackgroundWithBlock({ (suceed, error) -> Void in
                self.loadObjects()
            })
            
//            let theNote = noteStore.getNote(rowNumber)
            
            noteDetailViewController.theNote = object as Note
        }
    }
    
    @IBAction func saveNote(segue:UIStoryboardSegue) {
        
        
        if let indexPath = tableView.indexPathForSelectedRow() {
            // Must be editing a row
            
            var object: PFObject = self.objects[indexPath.row] as PFObject
            object.saveInBackgroundWithBlock({ (succeed, error) -> Void in
                self.loadObjects()
            })
//            noteStore.updateNote(indexPath.row)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        } else {
            
            // Must be adding a row
            let noteDetailViewController = segue.sourceViewController as NoteDetailViewController
            
            let theNote = noteDetailViewController.theNote
            
            // save the note
            theNote.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    self.loadObjects()
                    
//                    let lastRow = NSIndexPath(forRow: self.objects.count - 1, inSection: 0)
//                    self.tableView.insertRowsAtIndexPaths([lastRow], withRowAnimation: UITableViewRowAnimation.Automatic)
                    
                }
            })
//            noteStore.createNote(theNote)
            
            // update the screen
            
            var alert = UIAlertController(title: "Alert", message: "Note Saved", preferredStyle: UIAlertControllerStyle.Alert)
            
            
            
        }
    }
    
    
    
     
    
    override func queryForTable() -> PFQuery! {
        if searchText.isEmpty {
            var query = Note.query()
            query.orderByDescending("createdAt")
                        
            return query
        } else {
            var query = Note.query()
            var query1 = Note.query()
            query.whereKey("lowercaseTitle", containsString: searchText.lowercaseString)
            query1.whereKey("lowercaseText", containsString: searchText.lowercaseString)
            println(searchText.lowercaseString)
            
            var fullQuery = PFQuery.orQueryWithSubqueries([query, query1])
            
            return fullQuery
        }
    }
    
    
    
    
    // Single Query
    
//    override func queryForTable() -> PFQuery! {
//        if searchText.isEmpty {
//            var query = Note.query()
//            
//            return query
//        } else {
//            var query = Note.query()
////            var query1 = Note.query()
//            query.whereKey("lowercaseTitle", containsString: searchText.lowercaseString)
////            query1.whereKey("lowercaseText", containsString: searchText.lowercaseString)
//            println(searchText.lowercaseString)
//            
////            var fullQuery = PFQuery.orQueryWithSubqueries([query, query1])
//            
//            return query
//        }
//    }
    
    

    
    
//    override func queryForTable() -> PFQuery! {
//        var noteTitle = Note.query()
//        noteTitle.whereKey("lowercaseTitle", containsString: searchText.lowercaseString)
//        
//        var noteText = Note.query()
//        noteText.whereKey("lowercaseText", containsString: searchText.lowercaseString)
//        
//        if searchText.isEmpty {
//            return Note.query()
//        } else {
//            var noteCheck = PFQuery.orQueryWithSubqueries([noteTitle, noteText]) as PFQuery
//            
//            return noteCheck
//        }
//    }
    
    
    
    
    /* Grouping by Month
    
    First, you need to create an array of section headers, one for each unique month/year in your collection.
    Next, you need to pass in the secton number to this function,
    and return only those records in that section.  Alternatively you could create
    a two-dimensional array or dictionary....

    */



    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // reset state
        searchBar.text = nil
        searchText = ""
        // Hide the keyboard
        searchBar.resignFirstResponder()
        // reload data
        self.loadObjects()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // save state
        searchText = searchBar.text
        // hide keyboard
        searchBar.resignFirstResponder()
        // reload data
        self.loadObjects()
    }

    
}
