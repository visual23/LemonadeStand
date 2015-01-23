//
//  Recipe.swift
//  LemonadeStand
//
//  Created by Robb C. Bennett on 1/17/15.
//  Copyright (c) 2015 Visual23. All rights reserved.
//

import Foundation

class Recipe {
    
    var lemons = 0
    var iceCubes = 0
    
    var isAcidic = false
    var isEqualParts = false
    var isDiluted = false
    
    func makeLemonade() {
        var recipeMix: Double
        recipeMix = Double(lemons) / Double(iceCubes)
        
        if recipeMix > 1.0 {
            self.isAcidic = true;
        } else if recipeMix < 1.0 {
            isDiluted = true
        } else if recipeMix == 1.0 {
            isEqualParts = true
        }
    }
    
}