//
//  BallViewController.swift
//  Fallz
//
//  Created by Carl Henry Roosipuu on 3/5/18.
//  Copyright © 2018 Carl Henry Roosipuu. All rights reserved.
//

import UIKit

class BallViewController: UIViewController {

    let bg = UIImageView(image: UIImage(named: "bg")!)
    
    let fallzLabelImage = UIImageView(image: UIImage(named: "FallzLabel")!)
    
    let currentBallImage = UIImageView(image: UIImage(named: getBallImage())!)
    
    var ballsCollectionView: UICollectionView!
    
    let totalLinesLabel = UILabel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Background setup
        bg.center = self.view.center
        bg.frame = self.view.frame
        self.view.addSubview(bg)
        
        // Fallz Label
        fallzLabelImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(fallzLabelImage)
        // Leaderboard label Constraints
        fallzLabelImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        fallzLabelImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fallzLabelImage.widthAnchor.constraint(equalToConstant: 290).isActive = true
        fallzLabelImage.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        // Current Ball Image
        currentBallImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(currentBallImage)
        // Leaderboard label Constraints
        currentBallImage.topAnchor.constraint(equalTo: fallzLabelImage.bottomAnchor, constant: 15).isActive = true
        currentBallImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        currentBallImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        currentBallImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        // Balls Collection View
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 75, height: 75)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        ballsCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        ballsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        ballsCollectionView.backgroundColor = UIColor.clear
        self.view.addSubview(ballsCollectionView)
        ballsCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        ballsCollectionView.delegate = self
        ballsCollectionView.dataSource = self
        // Leaderboard label Constraints
        ballsCollectionView.topAnchor.constraint(equalTo: currentBallImage.bottomAnchor, constant: 20).isActive = true
        ballsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        ballsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        
        // Total  label Setup
        totalLinesLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLinesLabel.text = String(getTotalLines())
        totalLinesLabel.textAlignment = .center
        totalLinesLabel.textColor = .white
        totalLinesLabel.font = UIFont(name: "Helvetica-Bold", size: 60)
        self.view.addSubview(totalLinesLabel)
        // Total lines label Constraints
        totalLinesLabel.topAnchor.constraint(equalTo: ballsCollectionView.bottomAnchor).isActive = true
        totalLinesLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -14).isActive = true
        totalLinesLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        totalLinesLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        totalLinesLabel.text = String(getTotalLines())
    }
}

extension BallViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ballSkinList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        cell.ballImageView.image = UIImage(named: ballSkinList[indexPath.row].name)
        
        for ballName in getPurchasedBalls() {
            if ballName == ballSkinList[indexPath.row].name {
                cell.ballCostLabel.text = ""
                cell.ballImageView.alpha = 1
                break
            } else {
                cell.ballImageView.alpha = 0.25
                cell.ballCostLabel.text = String(ballSkinList[indexPath.row].cost)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
        
        if cell.ballImageView.alpha == 1 {
            currentBallImage.image = UIImage(named: ballSkinList[indexPath.row].name)
            saveBallImage(ball: ballSkinList[indexPath.row].name)
        } else {
            
            let gameOverAlert = UIAlertController(title: "Buy Ball", message: "Buy Ball for " + String(ballSkinList[indexPath.row].cost) + " points?" , preferredStyle: UIAlertControllerStyle.alert)

            
            // Yes - purchse ball
            gameOverAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                // if you have enough points
                if getTotalLines() >= ballSkinList[indexPath.row].cost {
                    saveTotalLines(totalLines: getTotalLines() - ballSkinList[indexPath.row].cost)
                    savePurchasedBall(purchasedBall: ballSkinList[indexPath.row].name)
                    collectionView.reloadData()
                    self.totalLinesLabel.text = String(getTotalLines())
                // if you do not have enough points
                } else {
                    let insufPoints = UIAlertController(title: "Insuficient Points", message: "You have less than " + String(ballSkinList[indexPath.row].cost) + " points!" , preferredStyle: UIAlertControllerStyle.alert)
                    insufPoints.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(insufPoints, animated: true, completion: nil)
                }
            }))
            
            gameOverAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            self.present(gameOverAlert, animated: true, completion: nil)
        }
    }
}
