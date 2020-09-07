//
//  GameViewController.swift
//  Project29
//
//  Created by Leonardo Diaz on 9/3/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var currentGame: GameScene?
    
    @IBOutlet weak var angleLabel: UILabel!
    @IBOutlet weak var angleSlider: UISlider!
    @IBOutlet weak var velocitySlider: UISlider!
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var playerNumber: UILabel!
    @IBOutlet weak var launchButton: UIButton!
    
    
    // Challenge 1
    @IBOutlet weak var player1ScoreLabel: UILabel!
    @IBOutlet weak var player2ScoreLabel: UILabel!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    
    var player1Score = 0 {
        didSet {
            player1ScoreLabel.text = "Score: \(player1Score)"
        }
    }
    
    var player2Score = 0 {
        didSet {
            player2ScoreLabel.text = "Score: \(player2Score)"
        }
    }
    
    var isGameOver = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player1Score = 0
        player2Score = 0
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame?.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        angleChanged(self)
        velocityChanged(self)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    @IBAction func launchTapped(_ sender: Any) {
        angleSlider.isHidden = true
        angleLabel.isHidden = true
        
        velocitySlider.isHidden = true
        velocityLabel.isHidden = true
        
        launchButton.isHidden = true
        
        currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number:Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }
        angleSlider.isHidden = false
        angleLabel.isHidden = false
        
        velocitySlider.isHidden = false
        velocityLabel.isHidden = false
        
        launchButton.isHidden = false
    }
    
    func updateScore(player: Int) {
        if player == 1 {
            player1Score += 1
        } else {
            player2Score += 1
        }
        
        if player1Score == 3 {
            player1ScoreLabel.text = "WINNER"
            toggleGame(bool: true)
        } else if player2Score == 3{
            player2ScoreLabel.text = "WiNNER"
            toggleGame(bool: true)
        }
    }
    
    @IBAction func newGameTapped(_ sender: Any) {
        toggleGame(bool: false)
        player1Score = 0
        player2Score = 0
        currentGame?.setupNewGame()
    }
    
    func toggleGame(bool: Bool) {
        isGameOver = bool
        angleLabel.isHidden = bool
        angleSlider.isHidden = bool
        velocitySlider.isHidden = bool
        velocityLabel.isHidden = bool
        playerNumber.isHidden = bool
        launchButton.isHidden = bool
        gameOverLabel.isHidden = !bool
        newGameButton.isHidden = !bool
    }
    
}

