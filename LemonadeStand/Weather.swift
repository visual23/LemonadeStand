//
//  Weather.swift
//  LemonadeStand
//
//  Created by Robb C. Bennett on 1/16/15.
//  Copyright (c) 2015 Visual23. All rights reserved.
//

import Foundation
import UIKit

class Weather {
    
    var weather = 0
    var weatherIcon = UIImage(named: "")
    
    var coldLow: UInt32 = 30
    var coldHigh: UInt32 = 50
    var mildLow: UInt32 = 50
    var mildHigh: UInt32 = 70
    var sunnyLow: UInt32 = 70
    var sunnyHigh: UInt32 = 90
    var currentTemperature = 0
    var weatherDescription = "Mild"
    
    
    func checkWeather() {
        
        currentTemperature = Int(arc4random_uniform(coldHigh - coldLow) + coldLow)
        self.weather = Int(arc4random_uniform(UInt32(3)))
        println("weather = \(self.weather)")
        
        switch weather {
        case 0:
            weatherIcon = UIImage(named: "IconCold")
            currentTemperature = Int(arc4random_uniform(coldHigh - coldLow) + coldLow)
            weatherDescription = "Cold"
        case 1:
            weatherIcon = UIImage(named: "IconMild")
            currentTemperature = Int(arc4random_uniform(mildHigh - mildLow) + mildLow)
            weatherDescription = "Mild"
        case 2:
            weatherIcon = UIImage(named: "IconSunny")
            currentTemperature = Int(arc4random_uniform(sunnyHigh - sunnyLow) + sunnyLow)
            weatherDescription = "Sunny"
        default:
            weatherIcon = UIImage(named: "IconMild")
            currentTemperature = Int(arc4random_uniform(mildHigh - mildLow) + mildLow)
            weatherDescription = "Mild"
        }
        
    }
    
    func getTemperature(personName: String) -> String {
        
        return personName
    }
    
}