//
//  CustomCollectionViewCell.swift
//  Fallz
//
//  Created by Carl Henry Roosipuu on 3/5/18.
//  Copyright © 2018 Carl Henry Roosipuu. All rights reserved.
//
import Foundation
import UIKit

// Costum Tabelview cell
class CustomCollectionViewCell: UICollectionViewCell {
    
    let ballImageView = UIImageView()
    let ballSelectedImageView = UIImageView()
    let ballCostLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ballImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ballImageView.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        self.addSubview(ballImageView)
        
        // High score label Setup
        ballCostLabel.translatesAutoresizingMaskIntoConstraints = false
        ballCostLabel.text = ""
        ballCostLabel.textAlignment = .center
        ballCostLabel.textColor = .white
        ballCostLabel.font = UIFont(name: "Helvetica-Bold", size: 11)
        self.addSubview(ballCostLabel)
        // High score label Constraints
        ballCostLabel.topAnchor.constraint(equalTo: ballImageView.bottomAnchor).isActive = true
        ballCostLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        ballCostLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        ballCostLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        ballSelectedImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ballSelectedImageView.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        ballSelectedImageView.image = UIImage(named: "BallSelected")
        ballSelectedImageView.alpha = 0
        self.addSubview(ballSelectedImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
