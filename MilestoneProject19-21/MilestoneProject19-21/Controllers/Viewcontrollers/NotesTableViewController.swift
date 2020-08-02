//
//  NotesTableViewController.swift
//  MilestoneProject19-21
//
//  Created by Leonardo Diaz on 8/1/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    //MARK: - Properties
    let cellIdentifier = "notesCell"
    let segueIdentifier = "toDetailVC"
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        NoteController.shared.loadFromPersistence()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    //MARK: - Helper Methods
    
    func setupView(){
        navigationController?.navigationBar.prefersLargeTitles = true
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeButtonPressed))
        compose.tintColor = .systemYellow
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [spacer, compose]
        navigationController?.toolbar.barTintColor = .systemBackground
        title = "Notes"
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NoteController.shared.notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let notes = NoteController.shared.notes[indexPath.row]
        cell.textLabel?.text = notes.noteInfo
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = NoteController.shared.notes[indexPath.row]
            NoteController.shared.deleteNote(note: note)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // MARK: - Navigation
    
    @objc func composeButtonPressed(){
        performSegue(withIdentifier: "create", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            guard let indexPath = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? DetailsViewController else { return }
            let selectedNote = NoteController.shared.notes[indexPath.row]
            destinationVC.note = selectedNote
        }
    }

}
