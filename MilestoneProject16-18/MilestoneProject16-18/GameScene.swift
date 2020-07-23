//
//  GameScene.swift
//  MilestoneProject16-18
//
//  Created by Leonardo Diaz on 7/22/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var restartLabel: SKLabelNode!
    var bulletsSprite: SKSpriteNode!
    var reloadLabel: SKLabelNode!
    var gameOverLabel: SKSpriteNode!
    var reloadSound: SKAction!
    var emptySound: SKAction!
    var shotSound: SKAction!
    var shotTextures = [SKTexture(imageNamed: "shots0"),
                        SKTexture(imageNamed: "shots1"),
                        SKTexture(imageNamed: "shots2"),
                        SKTexture(imageNamed: "shots3")]
    
    var bulletsInClip = 3 {
        didSet {
            bulletsSprite.texture = shotTextures[bulletsInClip]
        }
    }
    
    var countdownTimer: Timer?
    var createTargetsTimer: Timer?
    
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var timer = 60 {
        didSet {
            timerLabel.text = "\(timer)"
        }
    }
    
    var gameOver = false
    var reload = false
    var targetSpeed = 4.0
    var targetDelay = 0.8
    var targetsCreated = 0
    
    override func didMove(to view: SKView) {
        let woodBackground = SKSpriteNode(imageNamed: "wood-background")
        woodBackground.size = UIScreen.main.bounds.size
        woodBackground.position = CGPoint(x: 512, y: 384)
        woodBackground.blendMode = .replace
        addChild(woodBackground)
        
        let grass = SKSpriteNode(imageNamed: "grass-trees")
        grass.size = CGSize(width: 1025, height: 200)
        grass.position = CGPoint(x: 512, y: 384)
        addChild(grass)
        grass.zPosition = 100
        
        createWater()
        
        let curtainBackground = SKSpriteNode(imageNamed: "curtains")
        curtainBackground.size = UIScreen.main.bounds.size
        curtainBackground.position = CGPoint(x: 512, y: 384)
        curtainBackground.zPosition = 103
        addChild(curtainBackground)
        
        bulletsSprite = SKSpriteNode(imageNamed: "shots3")
        bulletsSprite.position = CGPoint(x: 170, y: 60)
        bulletsSprite.zPosition = 104
        addChild(bulletsSprite)
        
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 920, y: 720)
        scoreLabel.zPosition = 104
        addChild(scoreLabel)
        
        timerLabel = SKLabelNode(fontNamed: "Chalkduster")
        timerLabel.text = "60"
        timerLabel.position = CGPoint(x: 512, y: 720)
        timerLabel.zPosition = 105
        addChild(timerLabel)

        physicsWorld.gravity = .zero

        
        
        restartLabel = SKLabelNode(fontNamed: "Chalkduster")
        restartLabel.text = "New Game"
        restartLabel.position = CGPoint(x: 512, y: 264)
        restartLabel.zPosition = 600
        restartLabel.name = "restart"
        
        reloadSound = SKAction.playSoundFileNamed("reload.wav", waitForCompletion: false)
        emptySound = SKAction.playSoundFileNamed("empty.wav", waitForCompletion: false)
        shotSound = SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false)
        
        newGame()
        levelUp()
    }
    
    @objc func createTarget() {
        let target = Target()
        target.setup()

        let level = Int.random(in: 0...2)
        var movingRight = true
        
        switch level {
        case 0:
            // in front of the grass
            target.zPosition = 50
            target.position.y = 370
        case 1:
            // in front of the water background
            target.zPosition = 100.5
            target.position.y = 280

            movingRight = false
        default:
            // in front of the water foreground
            target.zPosition = 101.5
            target.position.y = 220
        }

        let move: SKAction

        if movingRight {
            target.position.x = 0
            move = SKAction.moveTo(x: 800, duration: 4.0)
        } else {
            target.position.x = 800
            target.xScale = -target.xScale
            move = SKAction.moveTo(x: 0, duration: 4.0)
        }

        let sequence = SKAction.sequence([move, SKAction.removeFromParent()])
        target.run(sequence)
        addChild(target)

        levelUp()
    }
    
    func levelUp() {
        targetSpeed *= 0.99
        targetDelay *= 0.99
        targetsCreated += 1
        if targetsCreated < 100 && !gameOver {
            DispatchQueue.main.asyncAfter(deadline: .now() + targetDelay) { [unowned self] in
                self.createTarget()
            }
        }
    }
    
    func createWater() {
        func animate(_ node: SKNode, distance: CGFloat, duration: TimeInterval) {
            let movementUp = SKAction.moveBy(x: 0, y: distance, duration: duration)
            let movementDown = movementUp.reversed()
            let sequence = SKAction.sequence([movementUp, movementDown])
            let repeatForever = SKAction.repeatForever(sequence)
            node.run(repeatForever)
        }

        let waterBackground = SKSpriteNode(imageNamed: "water-bg")
        waterBackground.position = CGPoint(x: 512, y: 270)
        let width = UIScreen.main.bounds.size.width
        waterBackground.size = CGSize(width: width, height: 150)
        waterBackground.zPosition = 101
        addChild(waterBackground)

        let waterForeground = SKSpriteNode(imageNamed: "water-fg")
        waterForeground.position = CGPoint(x: 512, y: 210)
        waterForeground.zPosition = 102
        waterForeground.size = CGSize(width: width, height: 150)
        addChild(waterForeground)

        animate(waterBackground, distance: 8, duration: 1.3)
        animate(waterForeground, distance: 12, duration: 1)
    }

    func newGame(){
        gameOver = false
        bulletsInClip = 3
        score = 0
        targetsCreated = 0
        targetSpeed = 4.0
        targetDelay = 0.8
        timer = 60
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameCountDown), userInfo: nil, repeats: true)
    }
    
    @objc func gameCountDown() {
        timer -= 1
        if timer == 0 {
            gameOver = true
            countdownTimer?.invalidate()
            createTargetsTimer?.invalidate()
            
            gameOverLabel = SKSpriteNode(imageNamed: "game-over")
            gameOverLabel.position = CGPoint(x: 512, y: 384)
            gameOverLabel.zPosition = 500
            addChild(gameOverLabel)
            addChild(restartLabel)
        }
    }
    
    func restartGame(){
        gameOverLabel.removeFromParent()
        restartLabel.removeFromParent()
        newGame()
        levelUp()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedAreas = nodes(at: location)
        
        if gameOver {
            for node in tappedAreas {
                if node.name == "restart"{
                    restartGame()
                    return
                }
            }
        }
        
            if timer > 0 && !gameOver {
                if reload {
                    run(reloadSound)
                    bulletsInClip = 3
                    reload = false
                    reloadLabel.removeFromParent()
                    return
                }
                
                if bulletsInClip > 0 {
                    run(shotSound)
                    bulletsInClip -= 1
                    let hitTargets = tappedAreas.filter({$0.name == "target"})
                        guard let targetHit = hitTargets.first else {
                            score -= 1
                            return
                    }
                        guard let parentNode = targetHit.parent as? Target else {
                            score -= 1
                            return
                    }
                        score += parentNode.points
                        parentNode.hit()
                        return
                } else {
                    run(emptySound)
                    reloadLabel = SKLabelNode(fontNamed: "Chalkduster")
                    reloadLabel.text = "RELOAD!"
                    reloadLabel.position = CGPoint(x: 512, y: 500)
                    reloadLabel.zPosition = 200
                    addChild(reloadLabel)
                    reload = true
                    return
            }
        }
    }
}
