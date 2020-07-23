//
//  Target.swift
//  MilestoneProject16-18
//
//  Created by Leonardo Diaz on 7/22/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import SpriteKit

class Target: SKNode {
    var target: SKSpriteNode!
    var stick: SKSpriteNode!
    var points: Int!
    
    func setup() {
        let stickType = Int.random(in: 0...2)
        let targetType = Int.random(in: 0...3)
        
        stick = SKSpriteNode(imageNamed: "stick\(stickType)")
        target = SKSpriteNode(imageNamed: "target\(targetType)")
        let scaleSize = Int.random(in: 0...3)
        
        switch scaleSize {
        case 0:
            points = 15
            target.setScale(0.4)
        case 1:
            points = 10
            target.setScale(0.6)
        case 2:
            points = 5
            target.setScale(0.7)
        case 3:
            points = 3
            target.setScale(0.8)
        default:
            points = 3
            target.setScale(0.8)
        }
        
        target.name = "target"
        target.position.y += 116
        stick.position.y = target.yScale + 8
        addChild(stick)
        addChild(target)
    }

    func hit() {
        removeAllActions()
        target.name = nil

        let animationTime = 0.2
        target.run(SKAction.colorize(with: .black, colorBlendFactor: 1, duration: animationTime))
        stick.run(SKAction.colorize(with: .black, colorBlendFactor: 1, duration: animationTime))
        run(SKAction.fadeOut(withDuration: animationTime))
        run(SKAction.moveBy(x: 0, y: -30, duration: animationTime))
        run(SKAction.scaleX(by: 0.8, y: 0.7, duration: animationTime))
    }
}
