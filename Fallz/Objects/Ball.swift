//
//  Ball.swift
//  Fallz
//
//  Created by Carl Henry Roosipuu on 1/24/18.
//  Copyright © 2018 Carl Henry Roosipuu. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class Ball: SKSpriteNode {
    
    var isMoveable : Bool = true
    
    init(scene: SKScene, xPositionInScene: CGFloat) {
        
        let ballTexture = SKTexture(imageNamed: getBallImage())
        let size = CGSize(width: scene.size.width * 0.14, height: scene.size.width * 0.14)
        
        

        super.init(texture: ballTexture, color: UIColor.clear, size: size)
        
        self.name = "ball"
        self.texture = ballTexture
        self.size = size
        self.position = CGPoint(x: xPositionInScene, y: (scene.childNode(withName: "levelLabel")?.position.y)! - self.size.height / 2)
        self.zPosition = 1
        
        // Ball physics body set up
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.angularDamping = 0.0
        self.physicsBody?.isDynamic = true
        self.physicsBody?.restitution = 0.8
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        // Colission Bit Masks
        self.physicsBody?.categoryBitMask = UInt32(GameScene.ballCategory)
        self.physicsBody?.collisionBitMask = UInt32(GameScene.lineCategory)
        self.physicsBody?.contactTestBitMask = UInt32(GameScene.lineCategory)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
