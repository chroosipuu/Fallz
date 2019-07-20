//
//  Lines.swift
//  Fallz
//
//  Created by Carl Henry Roosipuu on 1/23/18.
//  Copyright © 2018 Carl Henry Roosipuu. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class Line: SKSpriteNode {
    

    var lives:Int
    var touched:Bool = false
    var inContact:Bool = false
    
    init(scene: SKScene) {
        
        let lineTexture = SKTexture(imageNamed: "line1")
        let size = CGSize(width: scene.size.width * 0.03, height: scene.size.height * 0.129)
        self.lives = 1
        
        super.init(texture: lineTexture, color: UIColor.clear, size: size)
        
        self.name = "line"
        // Position
        let xPosition:CGFloat = roundTo(number: random(min: 45 / 1.5 , max: scene.size.width - 10 - 45 / 1.5 ), to: 10)
        let yPosition = random(min: self.size.height / 2, max: scene.size.height / 3 - size.height)
        self.position = CGPoint(x: xPosition, y: yPosition)
        self.zPosition = 1
        
        // Making sure they don't overlap
        
        var overLap = true
        while overLap {
            for node in scene.children {
                if node.name == "line" && self.intersects(node) {
                    let xPosition:CGFloat = roundTo(number: random(min: 45 / 1.5, max: scene.size.width - 10 - 45 / 1.5 ), to: 10)
                    let yPosition = random(min: self.size.height / 2, max: scene.size.height / 3 - size.height)
                    self.position = CGPoint(x: xPosition, y: yPosition)
                } else {
                    overLap = false
                }
            }
        }
        
        self.position = CGPoint(x: xPosition, y: -50)
        self.run(SKAction.moveTo(y: yPosition, duration: 0.5))

        // Line physics body set up
        self.physicsBody = SKPhysicsBody(texture: lineTexture, size: size)
        self.physicsBody?.pinned = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.friction = 0.00
        self.physicsBody?.isDynamic = false
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        // Colission Bit Masks
        self.physicsBody?.categoryBitMask = UInt32(GameScene.lineCategory)
        self.physicsBody?.collisionBitMask = UInt32(GameScene.ballCategory)
        self.physicsBody?.contactTestBitMask = UInt32(GameScene.ballCategory)
        
    }
    
    func breakLine(){
        self.texture = SKTexture(imageNamed: "CrackedLine")
        self.alpha = 0.5
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
