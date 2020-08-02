//
//  NoteController.swift
//  MilestoneProject19-21
//
//  Created by Leonardo Diaz on 8/1/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import Foundation

class NoteController {
     
    //MARK: - Singleton
    static let shared = NoteController()
    //MARK: - Source o truth
    var notes = [Note]()
    
    //MARK: - CUD
    func createNote(noteInfo: String){
        let newNote = Note(noteInfo: noteInfo)
        notes.append(newNote)
        saveToPersistence()
    }
    
    func updateNote(note: Note, noteInfo: String){
        note.noteInfo = noteInfo
        saveToPersistence()
    }
    
    func deleteNote(note: Note){
        guard let noteIndex = notes.firstIndex(of: note) else { return }
        notes.remove(at: noteIndex)
        saveToPersistence()
    }

    //MARK: - Persistence
    
    func saveToPersistence(){
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(notes)
            try data.write(to: fileURL())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadFromPersistence() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let decodedData = try decoder.decode([Note].self, from: data)
            notes = decodedData
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func fileURL() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = url[0].appendingPathComponent("Note.json")
        return fileURL
    }
}
