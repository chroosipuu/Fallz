//
//  GameViewController.swift
//  Fallz
//
//  Created by Carl Henry Roosipuu on 1/30/18.
//  Copyright © 2018 Carl Henry Roosipuu. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController, GADInterstitialDelegate {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if #available(iOS 11.0, *) {
            view.bounds = self.view.safeAreaLayoutGuide.layoutFrame
        }
        startGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    func startGame(){
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        scene.viewController = self
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)

    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var interstitial: GADInterstitial!
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let testAdUnitID = "ca-app-pub-3940256099942544/4411468910"
        let liveAdUnitID = "ca-app-pub-8023175220218228/2985780552"
        interstitial = GADInterstitial(adUnitID: liveAdUnitID)
        interstitial.delegate = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        print("loading ad...")
        interstitial.load(request)
    }
    
    func showAd(){
        print("show ad...")
        print(interstitial.debugDescription.description)
        if interstitial.isReady {
            print("ad ready...")
            interstitial.present(fromRootViewController: self)
        } else {
            print("ad not ready...")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.dismiss(animated: true, completion: nil)
    }

}

