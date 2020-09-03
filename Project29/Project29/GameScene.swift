//
//  GameScene.swift
//  Project29
//
//  Created by Leonardo Diaz on 9/3/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import SpriteKit

enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene {
    var buildings = [BuildingNode]()
    weak var viewController: GameViewController?
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        createBuildings()
    }
    
    func createBuildings(){
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            let size =  CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            print(currentX)
            currentX += size.width + 2
            
            let building = BuildingNode(color: .red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
    
    func launch(angle: Int, velocity: Int){
        
    }
}
