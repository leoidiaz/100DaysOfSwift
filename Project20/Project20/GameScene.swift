//
//  GameScene.swift
//  Project20
//
//  Created by Leonardo Diaz on 7/27/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge =  1024 + 22
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var launchLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    
    var launchesLeft = 10 {
        didSet {
            launchLabel.text = "Launches left: \(launchesLeft)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        addChild(background)
        
        // Challenge 1
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 10, y: 10)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        // Challenge 2
        launchLabel = SKLabelNode(fontNamed: "Chalkduster")
        launchLabel.position = CGPoint(x: 890, y: 735)
        launchLabel.fontSize = 25
        addChild(launchLabel)
        
        launchesLeft = 10
        
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "GAMEOVER"
        gameOverLabel.fontSize = 80
        gameOverLabel.position = CGPoint(x: 512, y: 450)
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int){
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        // Firework Image
        let firework = SKSpriteNode(imageNamed: "rocket")
        // When color is changed it is completely that color
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        case 2:
            firework.color = .red
        default:
            break
        }
        // Move in a curve like pattern
        let path = UIBezierPath()
        path.move(to: .zero)
        // Always move up and has the option to move left or right
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        
        node.run(move)
        // Emitter node =
        if let emmiter = SKEmitterNode(fileNamed: "fuse") {
            emmiter.position = CGPoint(x: 0, y: -22)
            node.addChild(emmiter)
        }
        
        fireworks.append(node)
        addChild(node)
    }
    
    @objc func launchFireworks(){
        
        if launchesLeft > 0 {
            
            launchesLeft -= 1
            
            let movementAmount: CGFloat = 1800
            
            switch Int.random(in: 0...3){
            case 0:
                // Fire Five, straight up
                createFirework(xMovement: 0, x: 512, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
            case 1:
                // Fire Five, in a fan
                createFirework(xMovement: 0, x: 512, y: bottomEdge)
                createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
                createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
                createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
                createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
            case 2:
                // fire five, from the left to the right
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
                createFirework(xMovement: movementAmount, x: leftEdge , y: bottomEdge + 300)
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
                createFirework(xMovement: movementAmount, x: leftEdge , y: bottomEdge + 100)
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
            case 3:
                // fire five, from the right to the left
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
                createFirework(xMovement: -movementAmount, x: rightEdge , y: bottomEdge + 300)
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
                createFirework(xMovement: -movementAmount, x: rightEdge , y: bottomEdge + 100)
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
            default:
                break
            }
        } else {
            gameTimer?.invalidate()
            addChild(gameOverLabel)
            
        }
        
    }
    
    func checkTouches(_ touches: Set<UITouch>){
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                // Select a firework of a different color, ignore it
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func explode(firework: SKNode){
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            let add = SKAction.run({ [weak self] in
                self?.addChild(emitter)
            })
            // Challenge 3
            let wait = SKAction.wait(forDuration: 1)
            let remove = SKAction.run({emitter.removeFromParent(); print("removing")})
            run(SKAction.sequence([add, wait, remove]))
        }
        firework.removeFromParent()
    }
    
    
    func explodeFireworks(){
        var numExploded = 0
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }
            
            if firework.name == "selected" {
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
}
