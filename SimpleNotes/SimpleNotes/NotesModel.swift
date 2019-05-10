//
//  NotesModel.swift
//  SimpleNotes
//
//  Created by Grayson Bianco on 5/6/19.
//  Copyright © 2019 Grayson Bianco. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class NotesModel {
    private var notes = [Note]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private static var instance: NotesModel?
    
    class var sharedModel: NotesModel {
        guard let shared = instance else {
            instance = NotesModel()
            return instance!
        }
        return shared
    }
    
    func saveNote(model: NoteDataModel) {
        let newNote = Note(context: context)
        newNote.snippet = model.snippet
        newNote.timeStamp = model.timeStamp
        newNote.title = model.title
        do {
            try context.save()
        } catch let error {
            print("Could not save note: \(String(describing: error))")
        }
    }
    
    func loadNotes() -> [Note] {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            notes = try context.fetch(request)
        } catch let error {
            print("Could not fetch notes: \(String(describing: error))")
        }
        return notes
    }
    
    func deleteNote(note: Note) -> Bool {
        context.delete(note)
        do {
            try context.save()
            return true
        } catch let error {
            print("Could not delete notes: \(String(describing: error))")
        }
        return false
    }
    
    func updateNote(_ note: Note, withTitle title: String? = nil, withSnippet snippet: String? = nil) -> Bool {
        var shouldSave = false
        if let title = title {
            note.setValue(title, forKey: "title")
            shouldSave = true
        }
        if let snippet = snippet {
            note.setValue(snippet, forKey: "snippet")
            shouldSave = true
        }
        guard shouldSave else { return false }
        do {
            try context.save()
            return true
        } catch let error {
            print("Could not delete notes: \(String(describing: error))")
        }
        return false
    }
}

struct NoteDataModel {
    var timeStamp: Date
    var title: String?
    var snippet: String?
}

extension NoteDataModel {
    init(note: Note) {
        self.timeStamp = note.timeStamp!
        self.snippet = note.snippet
        self.title = note.title
    }
}
