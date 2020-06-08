//
//  ViewController.swift
//  LunarLander
//
//  Created by Matthew Hanlon on 6/8/20.
//  Copyright © 2020 The Code Hub. All rights reserved.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    @IBOutlet var boostButton: UIButton!
    @IBOutlet var fuelLabel: UILabel!

    var fuelLevel = 100
    
    var lunarAnchor: LunarLander.Scene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load our AR anchor from the Reality Composer project
        let lunarAnchor = try! LunarLander.loadScene()
        
        // Configure how we behave when certain actions are taken.
        lunarAnchor.actions.mediumForce.onAction = { _ in
            self.didApplyMediumForce()
        }
        
        lunarAnchor.actions.massiveForce.onAction = { _ in
            self.didApplyMassiveForce()
        }
        
        // Add the lunar anchor to the scene
        arView.scene.anchors.append(lunarAnchor)
        
        self.lunarAnchor = lunarAnchor
    }
    
    @IBAction func giveBoost() {
        // This method will allow us to trigger applying force to our rocket from our code, here.
        self.lunarAnchor?.notifications.outsideTap.post()
    }

    func didApplyMediumForce() {
        // Here we can reduce our fuel reserves, if need be...
        print("Called boost!")
        self.reduceFuel(by:1)
    }
    
    func didApplyMassiveForce() {
        // Here we can reduce our fuel reserves, if need be...
        print("Called massive boost!")
        self.reduceFuel(by:20)
    }
    
    func reduceFuel(by usedFuel: Int) {
        if ( self.fuelLevel > usedFuel ) {
            self.fuelLevel -= usedFuel
            // Update our button...
            self.fuelLabel.text = "Fuel: \(self.fuelLevel)"
            self.fuelLabel.sizeToFit()
        } else {
            self.fuelLabel.text = "We're out of fuel!"
        }
    }

}

