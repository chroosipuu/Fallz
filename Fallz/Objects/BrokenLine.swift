//
//  BrokenLine.swift
//  Fallz
//
//  Created by Carl Henry Roosipuu on 1/29/18.
//  Copyright © 2018 Carl Henry Roosipuu. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class BrokenLine: SKSpriteNode {
    
    
    
    var touched:Bool = false
    
    init(scene: SKScene, linePosition: CGPoint, imageName: String) {
        let lineTexture = SKTexture(imageNamed: imageName)
        let size = CGSize(width: scene.size.width * 0.026, height: scene.size.height * 0.112)
        super.init(texture: lineTexture, color: UIColor.clear, size: size)
        
        self.name = "line"
        self.position = linePosition
        self.alpha = 0.5
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.pinned = false
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.isDynamic = true
        self.physicsBody?.velocity.dy = -50
        self.physicsBody?.angularVelocity = random(min: -1, max: 1)
        
        self.physicsBody?.categoryBitMask = UInt32(3)
        self.physicsBody?.collisionBitMask = UInt32(4)
        self.physicsBody?.contactTestBitMask = UInt32(3)
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
