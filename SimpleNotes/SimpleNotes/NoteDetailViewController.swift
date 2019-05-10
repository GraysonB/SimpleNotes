//
//  NoteDetailViewController.swift
//  SimpleNotes
//
//  Created by Grayson Bianco on 5/6/19.
//  Copyright © 2019 Grayson Bianco. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Photos

class NoteDetailViewController: UIViewController, UITextFieldDelegate {
    var note: Note?
    var noteModel: NoteDataModel?
    var dismissDelegate: DismissDelegate?
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var snippetTextView: UITextView!
    @IBOutlet weak var detailStackView: UIStackView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        titleTextView.insetsLayoutMarginsFromSafeArea = true
        titleTextView.delegate = self
        if let note = note {
            titleTextView.text = note.title
            snippetTextView.text = note.snippet
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let safeNote = note {
            safeNote.title = titleTextView.text
            safeNote.snippet = snippetTextView.text
            guard
                NotesModel.sharedModel.updateNote(safeNote, withTitle: titleTextView.text, withSnippet: snippetTextView.text)
            else {
                return
            }
        } else if var safeNoteModel = noteModel {
            safeNoteModel.title = titleTextView.text
            safeNoteModel.snippet = snippetTextView.text
            guard safeNoteModel.title.isNilOrEmpty || safeNoteModel.snippet.isNilOrEmpty else {
                noteModel = nil
                return
            }
            NotesModel.sharedModel.saveNote(model: safeNoteModel)
        }
        
        dismissDelegate?.dismissVC {
            guard let tableVC = dismissDelegate as? NotesTableViewController else { return }
            tableVC.shouldReloadDataSource()
            tableVC.tableView.reloadData()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        title = titleTextView.text
    }
}

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        guard let safeSelf = self else {
            return false
        }
        return safeSelf.count > 0
    }
}
