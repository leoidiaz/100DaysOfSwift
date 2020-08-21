//
//  GameScene.swift
//  Project26
//
//  Created by Leonardo Diaz on 8/18/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
    case player = 1
    case block = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case teleport = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet{
            scoreLabel.text =  "Score: \(score)"
        }
    }
    var isGamerOver = false
    var motionManager: CMMotionManager?
    var currentLevel = 1
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
        
        loadLevel(level: currentLevel)
        createPlayer(position: CGPoint(x: 96, y: 672))
    }
    
    func loadLevel(level: Int){
        let levelName = "level\(level)"
        
        guard let levelURL = Bundle.main.url(forResource: levelName, withExtension: "txt") else { fatalError("Could not find level1.txt in the app bundle") }
        guard let levelString = try? String(contentsOf: levelURL) else { fatalError("Could not load level1.txt from the app bundle.") }
        
        let lines = levelString.components(separatedBy: "\n")
        // good way of giving strings index like values
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
            
                if letter == "x" {
                    addWall(position: position, spriteNamed: "block", category: .block)
                } else if letter == "v" {
                    addVortex(position: position, spriteNamed: "vortex", category: .vortex, contact: .player)
                } else if letter == "s" {
                    addStar(position: position, spriteNamed: "star", category: .star, contact: .player)
                } else if letter == "f" {
                    addFinish(position: position, spriteNamed: "finish", category: .finish, contact: .player)
                } else if letter == "t" {
                    addTeleport(position: position, spriteNamed: "teleport", category: .teleport, contact: .player)
                } else if letter == " " {
                    // Do Nothing
                } else {
                    fatalError("Unknown level letter: \(letter)")
                }
            }
        }
    }
    // Challenge 1
    func addWall(position: CGPoint, spriteNamed: String, category: CollisionTypes){
        let node = SKSpriteNode(imageNamed: spriteNamed)
        node.position = position
        node.name = spriteNamed
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = category.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    
    func addVortex(position: CGPoint, spriteNamed: String, category: CollisionTypes, contact: CollisionTypes){
        let node = SKSpriteNode(imageNamed: spriteNamed)
        node.position = position
        node.name = spriteNamed
        
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = category.rawValue
        node.physicsBody?.contactTestBitMask = contact.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func addStar(position: CGPoint, spriteNamed: String, category: CollisionTypes, contact: CollisionTypes){
        let node = SKSpriteNode(imageNamed: spriteNamed)
        node.name = spriteNamed
        node.position = position
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = category.rawValue
        node.physicsBody?.contactTestBitMask = contact.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func addFinish(position: CGPoint, spriteNamed: String, category: CollisionTypes, contact: CollisionTypes){
        let node = SKSpriteNode(imageNamed: spriteNamed)
        node.name = spriteNamed
        node.position = position
        print(position)
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = category.rawValue
        node.physicsBody?.contactTestBitMask = contact.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    //Challenge2
    func addTeleport(position: CGPoint, spriteNamed: String, category: CollisionTypes, contact: CollisionTypes){
        let node = SKSpriteNode(imageNamed: spriteNamed)
        node.color = .cyan
        node.colorBlendFactor = 1.0
        node.position = position
        node.name = spriteNamed
        
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: -.pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = category.rawValue
        node.physicsBody?.contactTestBitMask = contact.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func createPlayer(position: CGPoint) {
        player = SKSpriteNode(imageNamed: "player")
        player.position = position
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.block.rawValue
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGamerOver == false else { return }
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
    
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGamerOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                if self?.currentLevel == 1 {
                    self?.createPlayer(position: CGPoint(x: 96, y: 672))
                } else if self?.currentLevel == 2 {
                    self?.createPlayer(position: CGPoint(x: 925, y: 692))
                }
                self?.isGamerOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "teleport"{
            player.physicsBody?.isDynamic = false
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            player.run(sequence) { [weak self] in
                self?.createPlayer(position: CGPoint(x: 96, y: 300))
            }
        } else if node.name == "finish" {
            // Challenge 2
            prepareForLevel()
            currentLevel += 1
            if currentLevel > 2 {
                currentLevel = 1
                score = 0
                loadLevel(level: currentLevel)
                createPlayer(position: CGPoint(x: 96, y: 672))
            } else {
                loadLevel(level: currentLevel)
                createPlayer(position: CGPoint(x: 925, y: 692))
            }
        }
    }
    
    func prepareForLevel() {
        let removeNodes = self.children.filter { $0.name != nil }
        
        for node in removeNodes {
            node.removeFromParent()
        }
        player.removeFromParent()
    }
}
