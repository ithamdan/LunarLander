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
    
    var lunarAnchor: LunarLander.StartScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load our AR anchor from the Reality Composer project
        let lunarAnchor = try! LunarLander.loadStartScene()
        
        /// Configure how we behave when certain actions are triggered
        // Configure how we behave when the medium force action is triggered
        lunarAnchor.actions.mediumForce.onAction = { _ in
            self.didApplyMediumForce()
        }
                
        // Add the lunar anchor to the scene
        arView.scene.anchors.append(lunarAnchor)
        
        self.lunarAnchor = lunarAnchor
    }
    
    @IBAction func giveBoost() {
        /// This method will allow us to trigger applying force to our rocket from our code, here.
        /// We *could* do this:
        // self.lunarAnchor?.notifications.outsideTap.post()
        /// And that would trigger the action sequence associated with the `outsideTap`
        /// behavior in the Reality Composer file.
        /// However, in this case, what we want is to control the velocity of
        /// our rocket... and maybe we want to be able to vary that, depending how long or
        /// how many times someone presses the button...
        if let rocketship = self.lunarAnchor?.rocketShip as? Entity & HasPhysics {
            // We need to change the physics mode from the dynamic mode
            // we set in the reality composer file to kinematic, to let RealityKit
            // we intend to drive the physics of this body
            rocketship.physicsBody?.mode = .kinematic
            // Set the velocity up at a pretty random value...
            let velocity: SIMD3<Float> = [0.0, 0.5, 0.0]
            rocketship.physicsMotion?.linearVelocity = velocity
            // After a little while, return the physics body to being dynamic
            // so RealityKit will apply gravity and all that good stuff to it.
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                rocketship.physicsBody?.mode = .dynamic
            }
            
            // After all this we want to still reduce our fuel a bit...
            self.reduceFuel(by:2)
        }
    }

    func didApplyMediumForce() {
        // Here we can reduce our fuel reserves, if need be...
        self.reduceFuel(by:1)
    }
    
    func didApplyMassiveForce() {
        // Here we can reduce our fuel reserves, if need be...
        self.reduceFuel(by:20)
    }
    
    func reduceFuel(by usedFuel: Int) {
        if ( self.fuelLevel > usedFuel ) {
            self.fuelLevel -= usedFuel
            // Update our button...
            self.fuelLabel.text = "Fuel: \(self.fuelLevel)"
        } else {
            self.fuelLabel.text = "We're out of fuel!"
            self.fuelLabel.textColor = .systemRed
        }
    }
}

