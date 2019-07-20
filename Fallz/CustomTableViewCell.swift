//
//  CostumTableViewCell.swift
//  Fallz
//
//  Created by Carl Henry Roosipuu on 2/6/18.
//  Copyright © 2018 Carl Henry Roosipuu. All rights reserved.
//

import Foundation
import UIKit

// Costum Tabelview cell
class CustomTableViewCell: UITableViewCell {
    
    let playerRank = UILabel()
    let playerName = UILabel()
    let playerScore = UILabel()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        playerRank.translatesAutoresizingMaskIntoConstraints = false
        playerName.translatesAutoresizingMaskIntoConstraints = false
        playerScore.translatesAutoresizingMaskIntoConstraints = false
        
        playerRank.font = UIFont(name: "Helvetica", size: 25)
        contentView.addSubview(playerRank)
        playerRank.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        playerRank.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        playerName.font = UIFont(name: "Helvetica", size: 20)
        playerName.textAlignment = .left
        contentView.addSubview(playerName)
        playerName.leadingAnchor.constraint(equalTo: self.playerRank.trailingAnchor, constant: 0).isActive = true
        
        playerScore.font = UIFont(name: "Helvetica", size: 25)
        playerScore.textAlignment = .right
        contentView.addSubview(playerScore)
        //playerScore.topAnchor.constraint(equalTo: playerName.bottomAnchor).isActive = true
        playerScore.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        playerScore.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        playerName.trailingAnchor.constraint(equalTo: playerScore.leadingAnchor).isActive = true
        
        
        let viewsDict = [
            "playerRank" : playerRank,
            "playerName" : playerName,
            "playerScore" : playerScore,
            ] as [String : Any]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[playerRank]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[playerName]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[playerScore]-|", options: [], metrics: nil, views: viewsDict))

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
