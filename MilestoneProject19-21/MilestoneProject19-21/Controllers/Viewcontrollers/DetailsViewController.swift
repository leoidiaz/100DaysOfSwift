//
//  DetailsViewController.swift
//  MilestoneProject19-21
//
//  Created by Leonardo Diaz on 8/1/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    // TODO: COLOR UI
    
    //MARK: - Properties
    @IBOutlet weak var textView: UITextView!
    
    var note: Note? {
        didSet{
            setupView()
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.becomeFirstResponder()
        notificationConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           navigationController?.setToolbarHidden(true, animated: false)
    }
    
    func setupView(){
        loadViewIfNeeded()
        guard let note = note else { return }
        textView.text = note.noteInfo
        textView.resignFirstResponder()
        
    }
    
    
    func notificationConfig(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let noteText = textView.text, !noteText.isEmpty else { presentErrorToUser(title: "Woops!", message: "You can't leave the note empty"); return }
        if let note = note {
            NoteController.shared.updateNote(note: note, noteInfo: noteText)
        } else {
            NoteController.shared.createNote(noteInfo: noteText)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification){
           guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
           
           let keyboardScreenEndFrame = keyboardValue.cgRectValue
           let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
           
           if notification.name == UIResponder.keyboardWillHideNotification {
               textView.contentInset = .zero
           } else {
               textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
           }
           
           textView.scrollIndicatorInsets = textView.contentInset
           
           let selectedRange = textView.selectedRange
           textView.scrollRangeToVisible(selectedRange)
       }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
       guard let noteText = textView.text, !noteText.isEmpty else { presentErrorToUser(title: "Woops!", message: "You can't leave the note empty"); return }
        present(UIActivityViewController(activityItems: [noteText], applicationActivities: nil), animated: true)
    }
    
    func presentErrorToUser(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
}
