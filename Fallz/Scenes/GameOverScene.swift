//
//  GameOverScene.swift
//  Fallz
//
//  Created by Carl Henry Roosipuu on 8/9/17.
//  Copyright © 2017 Carl Henry Roosipuu. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    // Variables
    
    var gameoverLabel = SKLabelNode(text: "Gameover")
    var scoreLabel:SKLabelNode!
    var highScoreLabel:SKLabelNode!
    var bgYPosition:CGFloat = 0
    
    var score:Int = 0
    let playAgainButton = SKSpriteNode(imageNamed: "playAgain")

    
    override func didMove(to view: SKView) {
        
        // Background
        let background = SKSpriteNode(imageNamed: "bg")
        background.name = "bg"
        background.size = CGSize(width: self.frame.width, height: self.frame.width * 5.3)
        background.anchorPoint = CGPoint(x: 0.5, y: 0)
        background.position = CGPoint(x: self.frame.width/2, y: bgYPosition)
        background.zPosition = -1
        self.addChild(background)
        background.run(SKAction.moveTo(y: self.frame.height-background.frame.height, duration: 1.5))
        
        // Gameover Label
        gameoverLabel.fontName = "Helvetica"
        gameoverLabel.fontSize = 80
        gameoverLabel.fontColor = UIColor.white
        gameoverLabel.zPosition = 0
        gameoverLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height - gameoverLabel.fontSize)
        self.addChild(gameoverLabel)
        
        // Score label setup
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = UIColor.white
        scoreLabel.zPosition = 0
        scoreLabel.position = CGPoint(x: self.frame.width/2, y: gameoverLabel.position.y - gameoverLabel.fontSize)
        self.addChild(scoreLabel)
        
        // High score label setup
        scoreLabel = SKLabelNode(text: "High score: \(getHighScore())")
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = UIColor.white
        scoreLabel.zPosition = 0
        scoreLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.addChild(scoreLabel)
        
        // Play again button setup
        playAgainButton.name = "playAgain"
        playAgainButton.size = CGSize(width: 250, height: 75)
        playAgainButton.zPosition = 0
        playAgainButton.position = CGPoint(x: self.frame.width/2, y: playAgainButton.size.height)
        self.addChild(playAgainButton)
    }
    
    // Touch control
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let positionInScene = touch?.location(in: self)
        let touchedNode = self.atPoint(positionInScene!)
        if let name = touchedNode.name{
            // Play again
            if name == "playAgain"{
                
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let game = GameScene(size: self.size)
                self.view?.presentScene(game, transition: transition)
            }
        }
    }
}

