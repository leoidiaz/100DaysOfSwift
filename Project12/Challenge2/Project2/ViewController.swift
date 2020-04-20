//
//  ViewController.swift
//  Project2
//
//  Created by Leonardo Diaz on 3/10/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsAsked = 0
    // Project 12 Challange 2
    let defaults = UserDefaults.standard
    var savedScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["estonia", "france", "germany", "ireland","italy", "monaco","nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(checkScore))
        load()
    }
    
    
    @objc func checkScore (){
        let ac = UIAlertController(title: "Score", message: "\(score) out of 10 Questions", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Resume", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)

        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        let findCountry = countries[correctAnswer].uppercased()
        title = "\(findCountry) -- SCORE: \(score)"
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        
        var title: String
        questionsAsked += 1
        
        if sender.tag == correctAnswer{
            title = "Correct"
            score += 1
        } else {
            title = "Wrong, you selected: \(countries[sender.tag].uppercased())"
            score -= 1
        }
        
        if questionsAsked == 3 {
            self.title = "SCORE: \(score)"
            if savedScore < score {
                savedScore = score
                highScoreAlert()
            } else {
                results()
            }
        } else {
            let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }
    }
    // Project 12 Challange 2 
    func load(){
        defaults.integer(forKey: "HighScore")
    }
    
    func save(){
        defaults.set(savedScore, forKey: "HighScore")
    }
    // Project 12 Challange 2
    func highScoreAlert(){
        let alertController = UIAlertController(title: "New High Score!", message: "\(savedScore) / 10!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay!", style: .cancel, handler: results))
        present(alertController, animated: true)
    }
    
    func results(action: UIAlertAction! = nil){
        let finalAlert = UIAlertController(title: title, message: "Your final score is \(score) / \(questionsAsked) \n High Score: \(savedScore)", preferredStyle: .alert)
        finalAlert.addAction(UIAlertAction(title: "Try Again?", style: .default, handler: askQuestion))
        
        score = 0
        correctAnswer = 0
        questionsAsked = 0
        
        save()
        present(finalAlert, animated: true)
    }
}

