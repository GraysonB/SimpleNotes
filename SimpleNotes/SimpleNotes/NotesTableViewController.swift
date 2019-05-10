//
//  NotesTableView.swift
//  SimpleNotes
//
//  Created by Grayson Bianco on 5/6/19.
//  Copyright © 2019 Grayson Bianco. All rights reserved.
//

import Foundation
import UIKit

class NotesTableViewController: UITableViewController {
    private var notes = [Note]()
    
    // Mark: Initialization Setup
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        shouldReloadDataSource()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        shouldReloadDataSource()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    // Mark: TableView Setup
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note =  notes[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as? NotesCell else {
            let newCell = NotesCell(style: .subtitle, reuseIdentifier: "NotesCell")
            return newCell.setup(with: note)
        }
        return cell.setup(with: note)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let note = notes[indexPath.row]
            if NotesModel.sharedModel.deleteNote(note: note) {
                notes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "CellToDetailSegue":
            guard let cell = sender as? NotesCell, let detailVC = segue.destination as? NoteDetailViewController else {
                return
            }
            detailVC.dismissDelegate = self
            detailVC.note = cell.cellNote
            detailVC.title = cell.cellNote?.title
        case "AddButtonToDetailSegue":
            guard let detailVC = segue.destination as? NoteDetailViewController else {
                return
            }
            detailVC.dismissDelegate = self
            detailVC.title = "New Note"
            detailVC.noteModel = NoteDataModel(timeStamp: Date(), title: nil, snippet: nil)
        default:
            return
        }
    }
    
    func shouldReloadDataSource() {
        notes = NotesModel.sharedModel.loadNotes()
    }
}


protocol DismissDelegate: class {
    func dismissVC(withCompletion completion: () -> Void)
}

extension NotesTableViewController: DismissDelegate {
    func dismissVC(withCompletion completion: () -> Void) {
        completion()
    }
}
