//
//  GameOverViewController.swift
//  Fallz
//
//  Created by Carl Henry Roosipuu on 8/8/17.
//  Copyright © 2017 Carl Henry Roosipuu. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit

@available(iOS 9.0, *)
class LeaderboardViewController: UIViewController {
    
    struct Player {
        var name: String!
        var score: Int!
    }
    
    let highScoreView = UIView()
    let highScoreIcon = UIImageView(image: UIImage(named: "HSIcon")!)
    let highScoreLabel = UILabel()
    let leaderboardLabel = UILabel()
    let loginButton = FBLoginButton()
    let bg = UIImageView(image: UIImage(named: "bg")!)

    
    let leaderboard = UITableView()


    
    var players: [Player] = []
    var myName = ""
    var FBid = ""
    
    var databaseRef: DatabaseReference!

    

    override func viewDidLoad() {
        
        // Background setup
        bg.center = self.view.center
        bg.frame = self.view.frame
        self.view.addSubview(bg)
        
        // High Score View
        highScoreView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(highScoreView)
        highScoreView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5).isActive = true
        highScoreView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        highScoreView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // High score icon
        highScoreIcon.translatesAutoresizingMaskIntoConstraints = false
        highScoreView.addSubview(highScoreIcon)
        // High score icon Constraints
        highScoreIcon.topAnchor.constraint(equalTo: highScoreView.topAnchor).isActive = true
        highScoreIcon.leadingAnchor.constraint(equalTo: highScoreView.leadingAnchor).isActive = true
        highScoreIcon.heightAnchor.constraint(equalToConstant: 60).isActive = true
        highScoreIcon.widthAnchor.constraint(equalToConstant: 90).isActive = true

        // High score label Setup
        highScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        highScoreLabel.text = String(getHighScore())
        highScoreLabel.textColor = .white
        highScoreLabel.font = UIFont(name: "Helvetica-Bold", size: 60)
        highScoreView.addSubview(highScoreLabel)
        // High score label Constraints
        highScoreLabel.topAnchor.constraint(equalTo: highScoreView.topAnchor).isActive = true
        highScoreLabel.leadingAnchor.constraint(equalTo: self.highScoreIcon.trailingAnchor).isActive = true
        highScoreView.trailingAnchor.constraint(equalTo: highScoreLabel.trailingAnchor).isActive = true


        // Leaderboard Label
        leaderboardLabel.translatesAutoresizingMaskIntoConstraints = false
        leaderboardLabel.text = "Leaderboard"
        leaderboardLabel.textColor = .white
        leaderboardLabel.font = UIFont(name: "Helvetica-Bold", size: 30)
        leaderboardLabel.textAlignment = .center
        self.view.addSubview(leaderboardLabel)
        // Leaderboard label Constraints
        leaderboardLabel.topAnchor.constraint(equalTo: self.highScoreView.bottomAnchor).isActive = true
        leaderboardLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        leaderboardLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        // Facebook login
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.delegate = self
        view.addSubview(loginButton)
        loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        
        // Leaderboard
        leaderboard.translatesAutoresizingMaskIntoConstraints = false
        leaderboard.backgroundColor = UIColor.clear
        leaderboard.register(CustomTableViewCell.self, forCellReuseIdentifier: "myCell")
        leaderboard.delegate = self
        leaderboard.dataSource = self
        leaderboard.allowsSelection = false
        leaderboard.tableFooterView = UIView(frame: .zero)
        self.view.addSubview(leaderboard)
        // Leaderboard label Constraints
        leaderboard.topAnchor.constraint(equalTo: self.leaderboardLabel.bottomAnchor).isActive = true
        leaderboard.bottomAnchor.constraint(equalTo: self.loginButton.topAnchor, constant: -20).isActive = true
        leaderboard.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        leaderboard.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        players = []
        self.highScoreLabel.text = String(getHighScore())
        do {
            try updateFBScore()
            try getLeaderboard()
        } catch {
            print(error)
        }

        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if #available(iOS 11.0, *) {
            view.bounds = self.view.safeAreaLayoutGuide.layoutFrame
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        databaseRef.removeAllObservers()
    }
    
    
    
    // Get player names & scores from Firebase and add to players[]
    func getLeaderboard() throws {
        databaseRef = Database.database().reference().child("Scores")
        databaseRef.queryOrdered(byChild: "negScore").queryLimited(toLast: 100).observe(.childAdded) { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            self.players.append(Player(name: postDict["name"] as! String, score: postDict["score"] as! Int))
            self.players.sort(by: {$0.score > $1.score})
            self.leaderboard.reloadData()
        }
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


// MARK: - FBSDKLoginButtonDelegate
@available(iOS 9.0, *)
extension LeaderboardViewController: LoginButtonDelegate{
    
    func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult!, error: Error!) {
        do {
            try getUserFBData()
            try saveScoreToFB()
        } catch {
            print(error)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton!) {
        saveFBid(FBid: "")
        saveName(name: "")
    }
}


// MARK: - UITableViewDelgate & UITableViewDataSource
@available(iOS 9.0, *)
extension LeaderboardViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CustomTableViewCell
        if players.count < indexPath.row {
            return cell
        }
        cell.playerRank.text = String(indexPath.row + 1) + "."
        cell.playerRank.textColor = .white
        cell.playerName.text =  players[indexPath.row].name
        cell.playerName.textColor = .white
        cell.playerName.sizeToFit()
        cell.playerScore.text = String(players[indexPath.row].score)
        cell.playerScore.textColor = .white
        cell.backgroundColor = UIColor.clear
        return cell
    }
}


