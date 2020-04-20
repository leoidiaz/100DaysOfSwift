//
//  ViewController.swift
//  Project5
//
//  Created by Leonardo Diaz on 3/19/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    private let reuseIdentifier = "Cell"
    var allWords = [String]()
    var usedWords = [String]()
    
    var savedMainWord: String?
    // Project 12 Challenge 3
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetGame))
        
        // Access start.txt file from bundle with URL
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            // Turn the file into string seperated by the \n break
            if let startWords = try? String(contentsOf: startWordsURL){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["Houston, we have a problem"]
        }
        // Check if previous game started
        // Project 12 Challenge 3
        if let lastSaveWord = defaults.string(forKey: "SavedMainWord"){
            load(gameWord: lastSaveWord)
        } else {
            startGame()
        }
    }
    
    func startGame() {
        savedMainWord = allWords.randomElement()
        title = savedMainWord
        usedWords.removeAll(keepingCapacity: true)
        // Project 12 Challenge 3
        save()
        tableView.reloadData()
    }
    
    //MARK: - Prompt for Answer
    @objc func promptForAnswer(){
        let alertController = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak alertController] _ in
            guard let answer = alertController?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
    
    //MARK: - Prompt for game Reset
    
    @objc func resetGame(){
        let alertController = UIAlertController(title: "Do you want a new word?", message: nil, preferredStyle: .alert)
        let reset = UIAlertAction(title: "Yes", style: .destructive) { [weak self]  _ in
            self?.startGame()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(reset)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }
    
    //MARK: - Submit Method
    func submit(_ answer: String){
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(lowerAnswer, at: 0) // Capitalization bug fix
                    // Project 12 Challenge 3
                    defaults.set(usedWords, forKey: "SavedWords")
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                } else {
                    errorAlert(errorTitle: "Word not recognized", errorMessage: "You can't just make them up, you know!")
                }
            } else {
                errorAlert(errorTitle: "Word already used", errorMessage: "Be more original!")
            }
        } else {
            guard let title = title?.lowercased() else { return }
            errorAlert(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title)")
        }
    }
    
    //MARK: - Error Alert Controller Config
    
    func errorAlert(errorTitle: String, errorMessage: String){
        let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    //MARK: - isPossible check
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        if tempWord == word.lowercased() {return false} // Duplicate Check
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter){
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    //MARK: - isOriginal Check
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    //MARK: - isReal Check
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        if word.count < 3 {return false} // Word less than 3 check
        return misspelledRange.location == NSNotFound
    }
    
}
//MARK: - TableView Delegates

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    // Project 12 Challenge 3
    func load(gameWord: String) {
        savedMainWord = gameWord
        title = savedMainWord
        usedWords = defaults.object(forKey: "SavedWords") as? [String] ?? ["Houston, we have a problem"]
        tableView.reloadData()
    }
    
    func save() {
        defaults.set(usedWords, forKey: "SavedWords")
        defaults.set(savedMainWord, forKey: "SavedMainWord")
    }
}

