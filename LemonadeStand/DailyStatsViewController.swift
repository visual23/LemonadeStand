//
//  DailyStats.swift
//  LemonadeStand
//
//  Created by Robb C. Bennett on 1/17/15.
//  Copyright (c) 2015 Visual23. All rights reserved.
//

import Foundation
import UIKit

protocol DailyStatsViewControllerDelegate{
    func dailyStatsVCDidFinish(controller:DailyStatsViewController,restartGame: Bool, statsExceptTips:Bool)
}

class DailyStatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dailyStatsDelegate:DailyStatsViewControllerDelegate? = nil
    
    
    @IBOutlet weak var statsTableView: UITableView!
    
    @IBOutlet weak var returnToGameButton: UIButton!
    
    @IBOutlet weak var tipsRow: UIView!
    @IBOutlet weak var expensesRow: UIView!
    @IBOutlet weak var profitRow: UIView!
    
    
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var customersLabel: UILabel!
    @IBOutlet weak var cupsSoldLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var expensesLabel: UILabel!
    @IBOutlet weak var profitLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    var arrayOfStats: [Stats] = [Stats]()
    
    var gameStatus:String = ""
    var money = 0;
    var lemons = 0;
    var currentDay = 0
    var iceCubes = 0
    var weather = 0
    var todaysWeather = 0
    var todaysTemperature = 0
    var todaysWeatherDescription = "Mild"
    var customers = 0
    var cupsSold = 0
    var exceptTips = true
    var restartGame = false
    var tips : Float = 0
    var expenses : Float = 0
    var profit : Float = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Lobster 1.3", size: 22)!,  NSForegroundColorAttributeName: brownColor]

        self.returnToGameButton.layer.cornerRadius = 5
        if gameStatus == "active" {
            returnToGameButton.setTitle("Start Day \(currentDay + 1)", forState: UIControlState.Normal)
        }
        else {
            returnToGameButton.setTitle("Start A New Game", forState: UIControlState.Normal)
        }
        
        statsTableView.backgroundColor = UIColor.clearColor()
        statsTableView.separatorColor = UIColor.clearColor()
        
        println("At Stats - exceptTips = \(exceptTips)")
        
        self.setUpStats()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToGameButtonPressed(sender: UIButton) {
        
        if gameStatus == "over" {
            restartGame = true
        }
        
        dailyStatsDelegate!.dailyStatsVCDidFinish(self, restartGame: restartGame, statsExceptTips: exceptTips)
    }
    
    func setUpStats() {
        
        // Set weather icon
        var weatherIcon : String
        switch weather {
        case 0:
            weatherIcon = "IconBrownCold"
        case 1:
            weatherIcon = "IconBrownMild"
        case 2:
            weatherIcon = "IconBrownSunny"
        default:
            weatherIcon = "IconBrownMild"
        }
        
        println("weatherIcon = \(weatherIcon)")
        
        var stats0 = Stats(iconImage: "IconBrownCalendar", stat: "Game Over!")
        
        var stats1 = Stats(iconImage: "IconBrownCalendar", stat: "Day \(self.currentDay)")
        var stats2 = Stats(iconImage: "\(weatherIcon)", stat: "\(self.todaysWeatherDescription) at \(self.todaysTemperature)°")
        var stats3 : Stats
        if self.customers == 1 {
            stats3 = Stats(iconImage: "IconBrownCustomers", stat: "\(self.customers) Customer")
        }
        else {
            stats3 = Stats(iconImage: "IconBrownCustomers", stat: "\(self.customers) Customers")
        }
        
        var stats4 : Stats
        if self.cupsSold == 1 {
            stats4 = Stats(iconImage: "IconBrownCup", stat: "\(self.cupsSold) Cup sold")
        }
        else {
            stats4 = Stats(iconImage: "IconBrownCup", stat: "\(self.cupsSold) Cups sold")
        }
        
        var tipsConverted = NSString(format:"$%.2f", Float(self.tips))
        var stats5 = Stats(iconImage: "IconBrownTips", stat: "\(tipsConverted) In tips")
        
        var expensesConverted = NSString(format:"$%.2f", Float(self.expenses))
        var stats6  = Stats(iconImage: "IconBrownExpenses", stat: "\(expensesConverted) Spent on expenses")
        
        var stats7 : Stats
        var profitConverted = NSString(format:"$%.2f", Float(self.profit))
        
        //if self.profit <= 0 {
            //stats7 = Stats(iconImage: "IconBrownProfit", stat: "\(profitConverted) Loss for today")
        //}
        //else {
            stats7 = Stats(iconImage: "IconBrownProfit", stat: "\(profitConverted) Profit for today")
        //}
        
        
        arrayOfStats.append(stats1)
        arrayOfStats.append(stats2)
        arrayOfStats.append(stats3)
        arrayOfStats.append(stats4)
        if exceptTips{
            arrayOfStats.append(stats5)
        }
        arrayOfStats.append(stats6)
        arrayOfStats.append(stats7)
        
        // if game is over, show alert
        if gameStatus == "over" {
            let alert = UIAlertView()
            alert.title = "GAME OVER!"
            alert.message = "You don't have enough money or lemons to go another day. Please restart the game."
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfStats.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: StatsCustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as StatsCustomTableViewCell
        
        //cell.backgroundColor = UIColor.purpleColor()
        
        let stat = arrayOfStats[indexPath.row]
        
        cell.setCell(stat.iconImage, stat: stat.stat)
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func setWeatherIcon() {
      
        switch weather {
        case 0:
            self.weatherImage.image = UIImage(named: "IconBrownCold")
        case 1:
            self.weatherImage.image = UIImage(named: "IconBrownMild")
        case 2:
            self.weatherImage.image = UIImage(named: "IconBrownSunny")
        default:
            self.weatherImage.image = UIImage(named: "IconBrownMild")
        }
    }
}