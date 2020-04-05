//
//  ViewController.swift
//  Milestone Project 7-9
//
//  Created by Leonardo Diaz on 4/3/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //UI
    @IBOutlet weak var guessesLeft: UILabel!
    @IBOutlet weak var currentWord: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    // Stick Figure Parts
    @IBOutlet weak var rightArm: UILabel!
    @IBOutlet weak var leftArm: UILabel!
    @IBOutlet weak var rightLeg: UILabel!
    @IBOutlet weak var leftLeg: UILabel!
    @IBOutlet weak var torso: UILabel!
    @IBOutlet weak var emptyHead: UILabel!
    @IBOutlet weak var deadEmoji: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var stickFigure = [UILabel]()
    var letterButtons = [UIButton]()
    var selectedButton = [UIButton]()
    var solution = String()
    var usedLetters = [String]()
    
    var wrongGuesses = 0 {
        didSet{
            guessesLeft.text = "\(wrongGuesses) / 7"
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = UIColor.lightGray.cgColor
        textField.isUserInteractionEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(pauseAlert))
        
        setupFigure()
        createButtons()
        loadWords()
        checkMatch()
    }

    //MARK: - Clear Button
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        textField.text = ""
        
        for button in selectedButton {
            button.isHidden = false
        }
        
        selectedButton.removeAll()
        submitButton.titleLabel?.textColor = UIColor.white
    }
    
    //MARK: - Submit Button
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        selectedButton.removeAll()
        guard let guess = textField.text else { return }
        if guess.isEmpty {return}
        usedLetters.append(guess)
        checkMatch()
        
        // Check if wrong
        if !solution.contains(guess) {
            wrongGuesses += 1
            updateFigure(guess: wrongGuesses - 1)
            // Show another body part
        }
        
        //Prompts You Lost
        if wrongGuesses == 7 {
            showAlert(title: "You Lost!", buttonTitle: "Try again?", message: "The word was \(solution) \n Final Score: \(score)") { [weak self] _ in
                self?.usedLetters.removeAll()
                self?.loadWords()
                self?.checkMatch()
                self?.wrongGuesses = 0
                guard let letterButtons = self?.letterButtons else { return }
                for button in letterButtons {
                    button.isHidden = false
                }
                self?.setupFigure()
                self?.score = 0
            }
        }
        
        if currentWord.text == solution {
            currentWord.textColor = UIColor.green
            showAlert(title: "You Won!", buttonTitle: "Play again?", message: "Completed in \(usedLetters.count) guesses") { [weak self] _ in
                self?.usedLetters.removeAll()
                self?.loadWords()
                self?.checkMatch()
                self?.wrongGuesses = 0
                guard let letterButtons = self?.letterButtons else { return }
                for button in letterButtons {
                    button.isHidden = false
                }
                self?.setupFigure()
                self?.score += 1
                self?.currentWord.textColor = UIColor.white
            }
        }
        submitButton.titleLabel?.textColor = UIColor.white
        textField.text = ""
    }
    
    @objc func letterTapped(_ sender: UIButton){
        guard let textFieldText = textField.text else { return }
        if !textFieldText.isEmpty {return}
        
        guard let buttonTitle = sender.titleLabel?.text else {return}
        
        textField.text = textField.text?.appending(buttonTitle)
        selectedButton.append(sender)
        sender.isHidden = true
        
        submitButton.titleLabel?.textColor = UIColor.green
    }
    
    
    //MARK: - Create Buttons
    
    //Button Dimensions
    let width = 65
    let height = 35
    
    func createButtons() {
        for row in 0..<6{
            for column in 0..<5{
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
                letterButton.tintColor = UIColor.white
                letterButton.setTitle("A", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width , y: row * height, width: width, height: height)
                letterButton.frame = frame
                buttonView.addSubview(letterButton)
                letterButtons.append(letterButton)
                if letterButtons.count == 26 { return}
            }
        }
    }
    
    //MARK: - Load Words File
    func loadWords(){
        let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
        if let fileURL = Bundle.main.url(forResource: "words", withExtension: "txt"){
            if let contents = try? String(contentsOf: fileURL){
                var lines = contents.components(separatedBy: "\n")
                lines.shuffle()
                guard let randomWord = lines.randomElement() else { return } // Pick Random Word
                solution = randomWord.uppercased()
                print(solution)
            }
        }
        
        if letterButtons.count == alphabet.count{
            for letter in 0..<letterButtons.count{
                letterButtons[letter].setTitle(alphabet[letter], for: .normal)
            }
        }
    }
    
    //MARK: - Check Word Match
    
    func checkMatch(){
        var promptWord = ""
        
        for char in solution {
            let stringLetter = String(char)
            if usedLetters.contains(stringLetter) {
                promptWord += stringLetter
            } else {
                promptWord += "?"
            }
        }

        currentWord.text = promptWord
    }
    
    //MARK: - Show Alert Controller / Pause Alert Controller
    
    func showAlert(title: String, buttonTitle: String, message: String?, handler: @escaping (UIAlertAction) -> Void ){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    @objc func pauseAlert(){
        let pauseController = UIAlertController(title: "Paused", message: "Letters Used: \(usedLetters)", preferredStyle: .alert)
        let restart = UIAlertAction(title: "Restart", style: .destructive) { [weak self] _  in
            self?.usedLetters.removeAll()
            self?.loadWords()
            self?.checkMatch()
            self?.wrongGuesses = 0
            guard let letterButtons = self?.letterButtons else { return }
            for button in letterButtons {
                button.isHidden = false
            }
            self?.setupFigure()
            self?.score = 0
        }
        let resume = UIAlertAction(title: "Resume", style: .default)
        
        pauseController.addAction(restart)
        pauseController.addAction(resume)
        present(pauseController, animated: true)
    }
    
    //MARK: - Stick Figure Config
    
    func setupFigure(){
        stickFigure.removeAll()
        stickFigure += [rightArm, leftArm, rightLeg, leftLeg, torso, emptyHead, deadEmoji]
        for item in stickFigure { item.isHidden = true}
    }
    
    func updateFigure(guess: Int){
        stickFigure[guess].isHidden = false
    }
    
    
}

