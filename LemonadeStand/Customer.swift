//
//  Customer.swift
//  LemonadeStand
//
//  Created by Robb C. Bennett on 1/17/15.
//  Copyright (c) 2015 Visual23. All rights reserved.
//

import Foundation

import UIKit

class Customer {
    
    var favorsAcidicLemonade = false
    var favorsEqualPartsLemonade = false
    var favorsDilutedLemonade = false
    var tipsGood = false
    var tipsBad = false
    var tipsNone = false
    
    func createCustomer() {
        
        var preference: Double = 0.5
        
        preference = (Double(Int(arc4random_uniform(UInt32(10)))) + 1.0) * 0.1
        
        if preference < 0.4 {
            self.favorsAcidicLemonade = true
        } else if preference > 0.6 {
            self.favorsEqualPartsLemonade = true
        } else {
            self.favorsEqualPartsLemonade = true
        }
        
        // Get tipping prefernce
        let randomNumber = Int(arc4random_uniform(UInt32(3)))
        
        if randomNumber == 0 {
            self.tipsGood = true
        }
        else if randomNumber == 1 {
            self.tipsBad = true
        }
        else {
            self.tipsNone = true
        }
        
    }
    
}