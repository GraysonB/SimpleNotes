//
//  NotesCell.swift
//  SimpleNotes
//
//  Created by Grayson Bianco on 5/6/19.
//  Copyright © 2019 Grayson Bianco. All rights reserved.
//

import Foundation
import UIKit

class NotesCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var cellNote: Note?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setupCell()
    }
    
    func setup(with note: Note) -> NotesCell {
        self.cellNote = note
        if let title = note.title, title.count > 0 {
            self.titleLabel.text = title
        } else {
            self.titleLabel.text = note.snippet
        }
        self.subtitleLabel.text = NotesCell.dateFormatter.string(from: note.timeStamp!)
        return self
    }
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
