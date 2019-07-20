//
//  Helper.swift
//  Fallz
//
//  Created by Carl Henry Roosipuu on 1/24/18.
//  Copyright © 2018 Carl Henry Roosipuu. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit


// Function to chose random numbers within range
func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
}


//Round to nearest 10
func roundTo(number: CGFloat, to: CGFloat) -> CGFloat{
    return to * CGFloat(Int(number / to))
}

// ###---- NSUserDefaults ----### \\

// Save highscore to NSUserDefaults
func saveHighScore(score: Int) {
    if score > getHighScore() {
        UserDefaults.standard.set(score, forKey: "highScore")
    }
}


// Get highscore from NSUserDefaults
func getHighScore() -> Int {
    // Get saved score from UserDefaults
    var savedScore = 0
    if UserDefaults.standard.value(forKey: "highScore") != nil {
        savedScore = UserDefaults.standard.integer(forKey: "highScore")}
    return savedScore
}

// Save ball type to NSUserDefaults
func saveBallImage(ball: String) {
    UserDefaults.standard.set(ball, forKey: "ball")
}


// Get ball type from NSUserDefaults
func getBallImage() -> String {
    // Get saved score from UserDefaults
    var ball = "redBall"
    if UserDefaults.standard.value(forKey: "ball") != nil {
        ball = UserDefaults.standard.string(forKey: "ball")!}
    return ball
}

// Save total lines to NSUserDefaults
func savePurchasedBall(purchasedBall: String) {
    var balls = getPurchasedBalls()
    balls.append(purchasedBall)
    UserDefaults.standard.set(balls, forKey: "purchasedBalls")
}


// Get total lines type from NSUserDefaults
func getPurchasedBalls() -> [String] {
    // Get saved score from UserDefaults
    var purchasedBalls:[String] = ["redBall"]
    if UserDefaults.standard.value(forKey: "purchasedBalls") != nil {
        purchasedBalls = UserDefaults.standard.array(forKey: "purchasedBalls") as! [String]}
    return purchasedBalls
}

// Save total lines to NSUserDefaults
func saveTotalLines(totalLines: Int) {
    UserDefaults.standard.set(totalLines, forKey: "totalLines")
}


// Get total lines type from NSUserDefaults
func getTotalLines() -> Int {
    // Get saved score from UserDefaults
    var totalLines = 0
    if UserDefaults.standard.value(forKey: "totalLines") != nil {
        totalLines = UserDefaults.standard.integer(forKey: "totalLines")}
    return totalLines
}




// Save FBid to NSUserDefaults
func saveFBid(FBid: String) {
    UserDefaults.standard.set(FBid, forKey: "FBid")
}


// Get FBid from NSUserDefaults
func getFBid() -> String {
    // Get saved score from UserDefaults
    var FBid = ""
    if UserDefaults.standard.value(forKey: "FBid") != nil {
        FBid = UserDefaults.standard.string(forKey: "FBid")!}
    return FBid
}

// Save highscore to NSUserDefaults
func saveName(name: String) {
    UserDefaults.standard.set(name, forKey: "name")
}


// Get highscore from NSUserDefaults
func getMyName() -> String {
    // Get saved score from UserDefaults
    var name = ""
    if UserDefaults.standard.value(forKey: "name") != nil {
        name = UserDefaults.standard.string(forKey: "name")!}
    return name
}


// ###---- FaceBook ----### \\


// Get name and FBid
func getUserFBData() throws {
        // Create the graph request and connection
    let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields" : "id, name"])
    let connection = GraphRequestConnection()
        // Add requet for id and name to the connection & handel error
        connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
            if error != nil {
                return
            } else {
                let data = result as! [String : AnyObject]
                saveName(name: (data["name"] as? String)!)
                saveFBid(FBid: (data["id"] as? String)!)
            }
        })
        connection.start()

}


// Update Facebook Score
func updateFBScore() throws {
    if getFBid() != "" {
        let databaseRef = Database.database().reference()
        databaseRef.child("Scores").child(getFBid()).observeSingleEvent(of: .value) { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            if let FBScore = postDict["score"] {
                let FBScoreValue = FBScore as! Int
                if  FBScoreValue > getHighScore(){
                    saveHighScore(score: FBScoreValue)
                } else {
                    // save highscore to fb
                    do {
                        try saveScoreToFB()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}


// Save score to FB
func saveScoreToFB() throws {
    if getFBid() != "" {
        let name = getMyName()
        let score = getHighScore()
        let post : [String : Any] = ["name" : name, "score" : score, "negScore" : -score]
        let databaseRef = Database.database().reference()
        databaseRef.child("Scores").child(getFBid()).setValue(post)
    }
}


// ###---- BallSkins ----### \\
struct BallSkin{
    let cost:Int
    let name:String
}
let ballSkinList = [BallSkin(cost: 0, name: "redBall"),
                    BallSkin(cost: 100, name: "blueBall"),
                    BallSkin(cost: 3000, name: "basketBall"),
                    BallSkin(cost: 5000, name: "squareBall"),
                    BallSkin(cost: 8000, name: "starBall")]
//BallSkin(cost: 500, name: "greenBall"),
//BallSkin(cost: 750, name: "lightBlueBall"),
//BallSkin(cost: 1000, name: "pinkBall"),
//BallSkin(cost: 2000, name: "yellowBall"),
//BallSkin(cost: 3000, name: "grayBall"),
//BallSkin(cost: 7000, name: "trumpBall")







