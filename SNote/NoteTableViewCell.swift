//
//  NoteTableViewCell.swift
//  SNote
//
//  Created by Sean Livingston on 2/8/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//

import UIKit

class NoteTableViewCell: PFTableViewCell {

    
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteDate: UILabel!
    @IBOutlet weak var noteText: UILabel!

    func setupCell(theNote:Note) {
        noteTitle.text = theNote["title"] as? String
        noteText.text = theNote["text"] as? String
        noteDate.text = theNote.shortDate
    }

}
