//
//  NoteDetailViewController.swift
//  SNote
//
//  Created by Eleven Fifty on 2/8/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {
    
    
    var theNote = PFObject()
    
    
    @IBOutlet weak var noteTitle: UITextField!
    
    
    @IBOutlet weak var noteText: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTitle.text = theNote["title"] as String
        noteText.text = theNote["text"] as String
        
        noteText.becomeFirstResponder() // makes body first responder.
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        theNote["title"] = noteTitle.text
        theNote["text"] = noteText.text
    }
    
    
}
