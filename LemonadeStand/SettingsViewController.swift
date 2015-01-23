//
//  SettingsViewController.swift
//  LemonadeStand
//
//  Created by Robb C. Bennett on 1/15/15.
//  Copyright (c) 2015 Visual23. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsViewControllerDelegate{
    func settingsVCDidFinish(controller:SettingsViewController,settingsRestartGame:Bool, settingsCupPrice:Float, settingsExceptTips:Bool)
}

class SettingsViewController: UIViewController {
    
    var settingsDelegate:SettingsViewControllerDelegate? = nil

    
    @IBOutlet weak var settingsBackButton: UIButton!
    @IBOutlet weak var tipsSwitch: UISwitch!
    @IBOutlet weak var resetGameButton: UIButton!
    @IBOutlet weak var cupPriceLabel: UILabel!
    @IBOutlet weak var cupPriceStepper: UIStepper!
    
    var restartGame = false
    var cupPrice : Float = 1
    var exceptTips = true
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set font for Navigation Bar title
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Lobster 1.3", size: 22)!,  NSForegroundColorAttributeName: brownColor]
        
        self.resetGameButton.layer.cornerRadius = 5
        
        tipsSwitch.addTarget(self, action: Selector("tipsSwitchStateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        println("view did load - exceptTips = \(exceptTips)")
        tipsSwitch.setOn(exceptTips, animated: true)
        
        cupPriceStepper.wraps = true
        cupPriceStepper.autorepeat = true
        cupPriceStepper.maximumValue = 10
        cupPriceStepper.value = Double(cupPrice)
        
        var cupPriceConverted = NSString(format:"$%.2f", cupPrice)
        cupPriceLabel.text = "\(cupPriceConverted)"
        
    }    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    func tipsSwitchStateChanged(switchState: UISwitch) {
        if switchState.on {
            println("The Switch is On")
            exceptTips = true
        } else {
            println("The Switch is Off")
            exceptTips = false
        }
        
        println("exceptTips = \(exceptTips)")
    }
    
    @IBAction func resetGameButtonPressed(sender: UIButton) {
        restartGame = true
    }
    
    @IBAction func cupPriceStepperPressed(sender: UIStepper) {
       
       var cupPriceConverted = NSString(format:"$%.2f", sender.value)
        var senderValue = sender.value
        self.cupPrice = Float(senderValue)
        
       cupPriceLabel.text = "\(cupPriceConverted)"
    }
    
    @IBAction func settingsBackButtonPressed(sender: UIButton) {
        settingsDelegate!.settingsVCDidFinish(self, settingsRestartGame: restartGame, settingsCupPrice: cupPrice, settingsExceptTips: exceptTips)
    }
    
    
    
}
