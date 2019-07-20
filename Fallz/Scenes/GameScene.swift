//
//  GameScene.swift
//  Fallz
//
//  Created by Carl Henry Roosipuu on 8/8/17.
//  Copyright © 2017 Carl Henry Roosipuu. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit
import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var viewController: GameViewController!
    
    let levelLabel = SKLabelNode(text: "Score: 0")
    var score = 0
    var linesAmount = 3
    let gameOverPopUp = SKNode()
    let ballSize : CGFloat = 45
    let bg = SKSpriteNode(imageNamed: "bg")

    
    static let ballCategory: UInt8 = 1;
    static let lineCategory: UInt8  = 2;
    
    var gameOver = false
    var continueToMenue = false
    var bonus = 0
    

    
// <<< --- DID MOVE TO SCENE --- >>>
    override func didMove(to view: SKView) {
        
        // Creates physics border around view
        let bottomLessFrame: CGRect = CGRect(x: 0, y: -400, width: self.frame.size.width, height: self.frame.size.height + 400)
        let borderBody = SKPhysicsBody(edgeLoopFrom: bottomLessFrame)
        self.physicsBody = borderBody
        borderBody.friction = 0.01
        
        // Set up physics world
        physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -7)
        
        // Only touch with one finger
        self.view?.isMultipleTouchEnabled = false
        
        // Background
        bg.size = (self.view?.frame.size)!
        bg.position = CGPoint(x:(self.scene?.frame.width)! / 2, y: (self.scene?.frame.height)! / 2)
        bg.zPosition = -10
        self.addChild(bg)
        
        // Back icon setup
        let backIcon = SKSpriteNode(imageNamed: "backIcon")
        backIcon.size = CGSize(width: 25, height: 25)
        backIcon.zPosition = 1
        backIcon.anchorPoint = CGPoint(x: 0.5, y: 1)
        backIcon.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - 5)
        backIcon.name = "backIcon"
        self.addChild(backIcon)
        
        // High score label setup
        let highScoreLabel = SKLabelNode(text: String(getHighScore()))
        highScoreLabel.fontName = "Helvetica"
        highScoreLabel.fontSize = 20
        highScoreLabel.fontColor = UIColor.white
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x:(self.scene?.frame.width)! - 25, y: (self.scene?.frame.height)! - 25)
        self.addChild(highScoreLabel)
        
        // High score icon setup
        let highScoreIcon = SKSpriteNode(imageNamed: "HSIcon")
        highScoreIcon.size = CGSize(width: 30, height: 20)
        highScoreIcon.zPosition = 1
        highScoreIcon.anchorPoint = CGPoint(x: 0.5, y: 0)
        highScoreIcon.position = CGPoint(x: self.frame.width - 60, y: self.frame.height - 25)
        self.addChild(highScoreIcon)
        
        // Score label set up
        levelLabel.name = "levelLabel"
        levelLabel.fontName = "Helvetica"
        levelLabel.fontSize = 30
        levelLabel.fontColor = SKColor.white
        levelLabel.position = CGPoint(x: 5, y: self.frame.height - 30)
        levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.addChild(levelLabel)
        
        // Top line
        let topLine = SKSpriteNode(imageNamed: "topLine")
        topLine.size = CGSize(width: self.frame.width, height: 300)
        topLine.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        topLine.position = CGPoint(x: self.frame.width/2, y: self.frame.height-150+75/2)
        topLine.zPosition = 0
        topLine.name = "topLine"
        self.addChild(topLine)
        
        // Position lines
        self.createLines(linesAmount: linesAmount)
    }
// <<< --- END DID MOVE TO SCENE --- >>>
    
    
    
// <<< --- ACTION LISTENERS --- >>>
// TOUCH STARTED FUNCITON
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let positionInScene = touch?.location(in: self)
        let touchedNode = self.atPoint(positionInScene!)
        if let name = touchedNode.name {
            if name == "backIcon"{
                let gameOverAlert = UIAlertController(title: "End Game", message: "Are you sure you want to end the game?", preferredStyle: UIAlertControllerStyle.alert)
                
                gameOverAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    self.endGame()
                }))
                
                gameOverAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                
                self.viewController.present(gameOverAlert, animated: true, completion: nil)
                
            }
        }
        // Check if ball already falling
        if (self.childNode(withName: "ball") == nil) && !gameOver {
            if (positionInScene?.x)! < self.size.width - ballSize/2 - 1 && (positionInScene?.x)! > ballSize/2 && (positionInScene?.y)! < self.frame.height - self.ballSize {
                let ball = Ball(scene: self, xPositionInScene: (positionInScene?.x)!)
                self.addChild(ball)

            }
        }
    }

    
// TOUCH MOVED FUNCITON
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let ballNode = self.childNode(withName: "ball") {
            let ball = ballNode as! Ball
            if ball.isMoveable {
                for touch: AnyObject in touches {
                    let location = touch.location(in: self)
                    if location.x < self.size.width - ballSize/2 - 1 && location.x > ballSize/2 {
                        ball.position.x = CGFloat(location.x)
                    }
                }
            }
        }
    }

    
// END THOUCH FUNCTION
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let ballNode = self.childNode(withName: "ball") {
            let ball = ballNode as! Ball
            ball.physicsBody?.affectedByGravity = true
            ball.physicsBody?.angularDamping = 1.0
            ball.isMoveable = false
        }
        if gameOver && continueToMenue {
            self.viewController.showAd()
            self.removeAllChildren()
        }
    }
    
    
// CONTACT FUNCTION
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "line"
            || contact.bodyA.node?.name == "line" && contact.bodyB.node?.name == "ball"{
            if let line = contact.bodyA.node as? Line {
                line.inContact = true
                lineTouched(line: line)
            } else if let line = contact.bodyB.node as? Line {
                line.inContact = true
                lineTouched(line: line)
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "line"
            || contact.bodyA.node?.name == "line" && contact.bodyB.node?.name == "ball"{
            if let line = contact.bodyA.node as? Line {
                line.inContact = false
            } else if let line = contact.bodyB.node as? Line {
                line.inContact = false
            }
        }
    }

    
// UPDATE FUNCITON
    override func update(_ currentTime: TimeInterval) {
        if self.childNode(withName: "ball") != nil {
            if (self.childNode(withName: "ball")?.position.y)! <= -ballSize && !gameOver{
                levelUp()
            }
        }
        for node in self.children{
            if node.name == "line" && (node.position.y) <= -100 {
                node.removeFromParent()
            }
            if node.name == "line" && (node.position.y) >= self.frame.height-150 {
                endGame()
            }
            if let line = node as? Line {
                if line.inContact {
                    lineTouched(line: line)
                }
            }
        }
    }
// <<< --- END ACTION LISTENERS --- >>>
    
    
    
// <<< --- SCENE FUCNTIONS --- >>>
    
// Level Up
    func levelUp(){
        self.childNode(withName: "ball")?.removeFromParent()
        self.bonus = 0
        for node in self.children {
            if let line = node as? Line {
                line.run(SKAction.move(by: CGVector(dx: 0, dy: self.frame.height * 0.075), duration: 0.5))
                if line.lives < 4 {
                    line.lives += 1
                }
                lineColor(line: line)
            }
        }
        self.createLines(linesAmount: self.linesAmount - 1)
    }

    
// Create lines
    func createLines(linesAmount: Int){
        for _ in 1...linesAmount {
            let line = Line(scene: self)
            self.addChild(line)
        }
    }
    
    
// When line touched
    func lineTouched(line: Line){
        line.lives -= 1
        lineColor(line: line)
        if line.lives < 1 {
            self.score += 1 + self.bonus
            self.levelLabel.text = "Score: \(self.score)"
            //bonus
            if bonus > 0 {
                let bonusLabel = SKLabelNode(text: "+" + String(self.bonus + 1))
                bonusLabel.fontSize = 15
                bonusLabel.alpha = 1
                bonusLabel.zPosition = 2
                bonusLabel.position = CGPoint(x: line.position.x, y: line.position.y + line.frame.height/2)
                bonusLabel.run(SKAction.sequence([SKAction.move(by: CGVector(dx: random(min: -20, max: 20),dy: 20), duration: 1.5), SKAction.removeFromParent()]))
                self.addChild(bonusLabel)
            }
            self.bonus += 1
            line.removeFromParent()
            dropLines(line: line)
        }
    }
    
    
// Line recolor
    func lineColor(line: Line) {
        line.texture = SKTexture(imageNamed: "line" + String(line.lives))
    }
    
    
// Broken lines falling
    func dropLines(line: Line) {
        let linePosition = line.position
        // topline
        let brokenLineTop = BrokenLine(scene: self, linePosition: linePosition, imageName: "BrokenLineTop")
        self.addChild(brokenLineTop)
        // botline
        let brokenLineBot = BrokenLine(scene: self, linePosition: linePosition, imageName: "BrokenLineBottom" )
        self.addChild(brokenLineBot)
    }
    
// End the game and transition to GameOverView
    func endGame(){
        if !gameOver {
            gameOver = true
            saveTotalLines(totalLines: getTotalLines() + score)
            saveHighScore(score: score)
            if let ball = self.scene?.childNode(withName: "ball") {
                ball.removeFromParent()
            }
            
            
            do {
                try saveScoreToFB()
            } catch {
                print(error)
            }
            
            // Create gameOverPopUp
            // gameOverLabel - gameOverPopUp
            let gameOverLabel = SKLabelNode(text: "Game Over")
            gameOverLabel.fontSize = 60
            gameOverLabel.fontName = "Helvetica-Bold"
            gameOverLabel.alpha = 1
            gameOverLabel.zPosition = 1
            gameOverLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height - 100)
            self.gameOverPopUp.addChild(gameOverLabel)
            
            // Score label - gameOverPopUp
            let scoreLabel = SKLabelNode(text: "Score: " + String(self.score))
            scoreLabel.fontSize = 60
            scoreLabel.fontName = "Helvetica-Bold"
            scoreLabel.alpha = 1
            scoreLabel.zPosition = 1
            scoreLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
            self.gameOverPopUp.addChild(scoreLabel)
            
            // Tap to continue - gameOverPopUp
            let tapToContinueLabel = SKLabelNode(text: "Tap to continue")
            tapToContinueLabel.fontSize = 40
            tapToContinueLabel.fontName = "Helvetica-Bold"
            tapToContinueLabel.alpha = 0.3
            tapToContinueLabel.zPosition = 1
            tapToContinueLabel.position = CGPoint(x: self.frame.width/2, y: 50)
            self.gameOverPopUp.addChild(tapToContinueLabel)

            
            // Position and name pop up
            self.gameOverPopUp.position = CGPoint(x: 0, y: 0)
            self.gameOverPopUp.zPosition = 10
            self.gameOverPopUp.name = "gameOverPopUp"
            
            // Drop all lines
            let dropLines = SKAction.run{
                for node in self.children{
                    if node.name == "line"{
                        node.physicsBody?.pinned = false
                        node.physicsBody?.affectedByGravity = true
                        node.physicsBody?.isDynamic = true
                    }
                }
            }

            let gameOverPopUp = SKAction.run{
                self.scene?.childNode(withName: "backIcon")?.removeFromParent()
                self.scene?.childNode(withName: "topLine")?.removeFromParent()
                self.addChild(self.gameOverPopUp)
            }
            
            let readyToConinue = SKAction.run {
                self.continueToMenue = true
            }

            // Run the action sequence
            run(SKAction.sequence([SKAction.wait(forDuration: 0.5), dropLines, SKAction.wait(forDuration: 1.5), gameOverPopUp, SKAction.wait(forDuration: 0.5), readyToConinue]))
        }
    }
    
    
}
