//
//  LeaderboardViewController.swift
//  Fallz
//
//  Created by Carl Henry Roosipuu on 3/5/18.
//  Copyright © 2018 Carl Henry Roosipuu. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    let bg = UIImageView(image: UIImage(named: "bg")!)
    
    let highScoreView = UIView()
    let highScoreIcon = UIImageView(image: UIImage(named: "HSIcon")!)
    let highScoreLabel = UILabel()
    
    let fallzLabelImage = UIImageView(image: UIImage(named: "FallzLabel")!)
    
    let fallzLogo = UIView()
    let fallzLogoLines = UIImageView(image: UIImage(named: "LogoLines")!)
    let fallzLogoBall = UIImageView(image: UIImage(named: getBallImage())!)
    
    let playButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Background setup
        bg.center = self.view.center
        bg.frame = self.view.frame
        self.view.addSubview(bg)
        
        // High Score View
        highScoreView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(highScoreView)
        highScoreView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5).isActive = true
        highScoreView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        highScoreView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // High score icon
        highScoreIcon.translatesAutoresizingMaskIntoConstraints = false
        highScoreView.addSubview(highScoreIcon)
        // High score icon Constraints
        highScoreIcon.topAnchor.constraint(equalTo: highScoreView.topAnchor).isActive = true
        highScoreIcon.leadingAnchor.constraint(equalTo: highScoreView.leadingAnchor).isActive = true
        highScoreIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        highScoreIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        // High score label Setup
        highScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        highScoreLabel.text = String(getHighScore())
        highScoreLabel.textColor = .white
        highScoreLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        highScoreView.addSubview(highScoreLabel)
        // High score label Constraints
        highScoreLabel.topAnchor.constraint(equalTo: highScoreView.topAnchor).isActive = true
        highScoreLabel.leadingAnchor.constraint(equalTo: self.highScoreIcon.trailingAnchor).isActive = true
        highScoreView.trailingAnchor.constraint(equalTo: highScoreLabel.trailingAnchor).isActive = true
        
        // Fallz Label
        fallzLabelImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(fallzLabelImage)
        // Leaderboard label Constraints
        fallzLabelImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        fallzLabelImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fallzLabelImage.widthAnchor.constraint(equalToConstant: 290).isActive = true
        fallzLabelImage.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        // Fallz Logo Lines
        fallzLogoLines.translatesAutoresizingMaskIntoConstraints = false
        fallzLogo.addSubview(fallzLogoLines)

        
        // Fallz Logo Lines
        fallzLogoBall.translatesAutoresizingMaskIntoConstraints = false
        fallzLogo.addSubview(fallzLogoBall)

        
        // Fallz Logo View
        fallzLogo.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(fallzLogo)
        // Logo View Constraints
        fallzLogo.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        fallzLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fallzLogo.widthAnchor.constraint(equalToConstant: 100).isActive = true
        fallzLogo.heightAnchor.constraint(equalToConstant: 300).isActive = true
        // Logo Lines Constraints
        fallzLogoLines.topAnchor.constraint(equalTo: fallzLogo.topAnchor).isActive = true
        fallzLogoLines.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fallzLogoLines.widthAnchor.constraint(equalToConstant: 100).isActive = true
        fallzLogoLines.heightAnchor.constraint(equalToConstant: 160).isActive = true
        // Logo Ball Constraints
        fallzLogoBall.bottomAnchor.constraint(equalTo: fallzLogo.bottomAnchor).isActive = true
        fallzLogoBall.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fallzLogoBall.widthAnchor.constraint(equalToConstant: 100).isActive = true
        fallzLogoBall.heightAnchor.constraint(equalToConstant: 100).isActive = true

        // Play button
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("PLAY", for: .normal)
        playButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 60)
        playButton.setTitleColor(.white, for: .normal)
        playButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        self.view.addSubview(playButton)
        playButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -14).isActive = true
        playButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        playButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true


    }
    
    // playButton action
    @objc func playButtonAction(sender: UIButton!) {
        performSegue(withIdentifier: "segueToGameView", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fallzLogoBall.image = UIImage(named: getBallImage())!
        highScoreLabel.text = String(getHighScore())
    }

}
