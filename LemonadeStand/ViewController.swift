//
//  ViewController.swift
//  LemonadeStand
//
//  Created by Robb C. Bennett on 1/15/15.
//  Copyright (c) 2015 Visual23. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DailyStatsViewControllerDelegate, SettingsViewControllerDelegate{
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var weatherImage: UIImageView!
    
    // HUD labels
    
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var lemonsLabel: UILabel!
    @IBOutlet weak var iceCubesLabel: UILabel!
    @IBOutlet weak var daylabel: UILabel!
    
    // HUD Icons
    
    @IBOutlet weak var lemonImage: UIImageView!
    
    //
    
    @IBOutlet weak var storeIconLemon: UIImageView!
    @IBOutlet weak var storeIconIceCubes: UIImageView!
    @IBOutlet weak var mixIconLemon: UIImageView!
    @IBOutlet weak var mixIconIceCubes: UIImageView!
    
    
    
    ///////// Store
    
    // Lemons
    @IBOutlet weak var storeLemonsMinusButton: UIButton!
    @IBOutlet weak var storeLemonsPlusButton: UIButton!
    @IBOutlet weak var storeLemonsSelected: UILabel!
    
    // Ice Cubes
    @IBOutlet weak var storeIceCubesMinusButton: UIButton!
    @IBOutlet weak var storeIceCubesPlusButton: UIButton!
    @IBOutlet weak var storeIceCubesSelected: UILabel!
    
    ///////// Mix
    
    // Lemons
    @IBOutlet weak var mixLemonsMinusButton: UIButton!
    @IBOutlet weak var mixLemonsPlusButton: UIButton!
    @IBOutlet weak var mixLemonsSelected: UILabel!
    
    // Ice Cubes
    @IBOutlet weak var mixIceCubesMinusButton: UIButton!
    @IBOutlet weak var mixIceCubesPlusButton: UIButton!
    @IBOutlet weak var mixIceCubesSelected: UILabel!
    
    // Start Button
    @IBOutlet weak var startDayButton: UIButton!
    
    var resources = Resources()
    var basket = Resources()
    
    // Current Day
    var currentDay = 1
    
    // Supply Prices
    var lemonPrice : Float = 2
    var iceCubesPrice : Float = 1
    
    // Price per cup
    var cupPrice : Float = 1
    
    var cupsSold = 0
    
    // Set up weather
    var currentWeather = Weather()
    
    // Set up mix
    var currentMix = Recipe()
    
    //Set up customers
    var customers:[Customer] = []
    var totalCustomers = 0;
    
    var todaysEarnings : Float = 0
    var expenses : Float = 0
    
    var gameStatus = "active"
    
    var exceptTips = true
    
    var todaysTips : Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBar.topItem?.title = "Lemonade Stand"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Lobster 1.3", size: 22)!,  NSForegroundColorAttributeName: brownColor]
        
        var nav = self.navigationController?.navigationBar
        nav?.tintColor = brownColor

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 158, height: 26))
        imageView.contentMode = .ScaleAspectFit

        let image = UIImage(named: "LemonadeStandLogo")
        imageView.image = image

        navigationItem.titleView = imageView
        
        self.startDayButton.layer.cornerRadius = 5
        
        resources.setStartUpFunds()
        currentWeather.checkWeather()
        updateHUD()
        
        storeLemonsMinusButton.enabled = false
        storeIceCubesMinusButton.enabled = false
        
        mixLemonsMinusButton.enabled = false
        mixIceCubesMinusButton.enabled = false
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "segueDailyStats" {
            
            if (currentMix.lemons == 0 || currentMix.iceCubes == 0) {
                
                let alert = UIAlertView()
                alert.title = "No Ingredients!"
                alert.message = "Please add lemons or ice cubes"
                alert.addButtonWithTitle("Ok")
                alert.show()
                
                return false
            }
            else {
                
                startDay()
                
                return true
            }
        }

        return true
    }
    
    func dailyStatsVCDidFinish(controller: DailyStatsViewController, restartGame: Bool, statsExceptTips: Bool) {
        // Check to see if we need to set up a new day or start a new game
        println("dailyStatsVCDidFinish called")
        println("restartGame = \(restartGame)")
        if !restartGame {
            self.setUpNewDay()
        }
        else {
            self.setUpNewGame()
        }
    }
    
    func settingsVCDidFinish(controller: SettingsViewController, settingsRestartGame: Bool, settingsCupPrice: Float, settingsExceptTips: Bool) {
        
        exceptTips = settingsExceptTips
        println("settingsVCDidFinish exceptTips = \(exceptTips)")
        cupPrice = settingsCupPrice
        println("new cupPrice = \(cupPrice)")
        
        if settingsRestartGame {
            setUpNewGame()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "segueDailyStats") {
            let dailyStatsVS = (segue.destinationViewController as UINavigationController).topViewController as DailyStatsViewController
            
            dailyStatsVS.gameStatus = gameStatus
            dailyStatsVS.currentDay = currentDay
            dailyStatsVS.weather = currentWeather.weather
            dailyStatsVS.todaysTemperature = currentWeather.currentTemperature
            dailyStatsVS.todaysWeatherDescription = currentWeather.weatherDescription
            dailyStatsVS.customers = totalCustomers
            dailyStatsVS.cupsSold = cupsSold
            dailyStatsVS.tips = todaysTips
            dailyStatsVS.expenses = (Float(currentMix.lemons) * lemonPrice) + (Float(currentMix.iceCubes) * iceCubesPrice)
            dailyStatsVS.profit = ((Float(cupsSold) * cupPrice) + todaysTips) - expenses
            dailyStatsVS.exceptTips = exceptTips
            println("todaysEarnings = \(todaysEarnings)")
            println("expenses = \((Float(currentMix.lemons) * lemonPrice) + (Float(currentMix.iceCubes) * iceCubesPrice))")
            println("Tracing total \(totalCustomers) customers today.")
            
            dailyStatsVS.dailyStatsDelegate = self
        }
        
        if (segue.identifier == "segueSettings") {
            let settingsVS = segue.destinationViewController as SettingsViewController;
            
            settingsVS.cupPrice = cupPrice
            settingsVS.exceptTips = exceptTips
            settingsVS.settingsDelegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This is for handling the unwind segue bug
    @IBAction func unwindSegue(segue: UIStoryboardSegue) { }
    
    // Button Actions
    @IBAction func storeLemonMinusButtonPressed(sender: UIButton) {
        resources.lemons -= 1
        basket.lemons -= 1
        resources.money += lemonPrice
        updateHUDLabels()
        updateStoreLabels()
        updateMixLabels()
        
        pulseIcon(self.storeIconLemon);
    }
    
    @IBAction func storeLemonPlusButtonPressed(sender: UIButton) {
        resources.lemons += 1
        basket.lemons += 1
        resources.money -= lemonPrice
        updateHUDLabels()
        updateStoreLabels()
        updateMixLabels()
        
        pulseIcon(self.storeIconLemon);
    }
    
    @IBAction func storeIceCubesMinusButtonPressed(sender: UIButton) {
        resources.iceCubes -= 1
        basket.iceCubes -= 1
        resources.money += iceCubesPrice
        updateHUDLabels()
        updateStoreLabels()
        updateMixLabels()
        
        pulseIcon(self.storeIconIceCubes);
    }
    
    @IBAction func storeIceCubesPlusButtonPressed(sender: UIButton) {
        resources.iceCubes += 1
        basket.iceCubes += 1
        resources.money -= iceCubesPrice
        updateHUDLabels()
        updateStoreLabels()
        updateMixLabels()
        
        pulseIcon(self.storeIconIceCubes);
        
    }
    
    ///////// Mix Actions
    
    @IBAction func mixLemonMinusButtonPressed(sender: UIButton) {
        currentMix.lemons -= 1
        resources.lemons += 1
        updateHUDLabels()
        updateMixLabels()
        
        pulseIcon(self.mixIconLemon);
    }
    
    @IBAction func mixLemonPlusButtonPressed(sender: UIButton) {
        currentMix.lemons += 1
        resources.lemons -= 1
        updateHUDLabels()
        updateMixLabels()
        
        pulseIcon(self.mixIconLemon);
    }
    
    @IBAction func mixIceCubesMinusButtonPressed(sender: UIButton) {
        currentMix.iceCubes -= 1
        resources.iceCubes += 1
        updateHUDLabels()
        updateMixLabels()
        
        pulseIcon(self.mixIconIceCubes);
    }
    
    @IBAction func mixIceCubesPlusButtonPressed(sender: UIButton) {
        currentMix.iceCubes += 1
        resources.iceCubes -= 1
        updateMixLabels()
        updateHUDLabels()
        
        pulseIcon(self.mixIconIceCubes);
    }
    
    @IBAction func startDayButtonPressed(sender: UIButton) {
        
    }
    
    func startDay() {
        
        println("Your day has started. Go make some money!")
        
        // Mix the lemonade
        currentMix.makeLemonade()
        
        // set expenses
        expenses = (Float(currentMix.lemons) * lemonPrice) + (Float(currentMix.iceCubes) * iceCubesPrice)
        
        if currentMix.isAcidic {
            println("The lemonade today is bitter")
        }
        else if currentMix.isEqualParts {
            println("The lemonade today is perfect")
        }
        else {
            println("The lemonade today is diluted")
        }
        
        totalCustomers = Int(arc4random_uniform(10 - 1) + 1)
        println("You had \(totalCustomers) customers today.")
        
        for var i = 0; i < totalCustomers; ++i {
            let customer = Customer()
            customer.createCustomer()
            customers.append(customer)
        }
        
        for var i = 0; i < totalCustomers; ++i {
            if currentMix.isAcidic && customers[i].favorsAcidicLemonade {
                println("Customer \(i) likes acidic lemonade and paid")
                //todaysEarnings = Float(todaysEarnings) + cupPrice
                //println("todaysEarnings = \(todaysEarnings)")
                
                // Get tip
                if exceptTips {
                    var tipAmount : Float = self.calulateTip(customers[i])
                    todaysTips += Float(tipAmount)
                    //todaysEarnings = (Float(todaysEarnings) + Float(tipAmount))
                }
                
                cupsSold += 1
            }
            else if currentMix.isEqualParts && customers[i].favorsEqualPartsLemonade {
                println("Customer \(i) likes equal parts lemonade and paid")
                
                //todaysEarnings = Float(todaysEarnings) + cupPrice
                //println("todaysEarnings = \(todaysEarnings)")
                
                // Get tip
                if exceptTips {
                    var tipAmount : Float = self.calulateTip(customers[i])
                    todaysTips += Float(tipAmount)
                    //todaysEarnings = (Float(todaysEarnings) + Float(tipAmount))
                }
                
                cupsSold += 1
            }
            else if currentMix.isDiluted && customers[i].favorsDilutedLemonade {
                println("Customer \(i) likes diluted lemonade and paid")
                //Float(todaysEarnings) + cupPrice
                //println("todaysEarnings = \(todaysEarnings)")
                
                // Get tip
                if exceptTips {
                    var tipAmount : Float = self.calulateTip(customers[i])
                    todaysTips += Float(tipAmount)
                    //todaysEarnings = (Float(todaysEarnings) + Float(tipAmount))
                }
                
                cupsSold += 1
            }
            else {
                println("Customer \(i) didn't like the lemonade mix today and walked away.")
            }
            
        }
        if (Float(cupsSold) * cupPrice) >= expenses {
            println("You made a profit")
            todaysEarnings = ((Float(cupsSold) * cupPrice) + todaysTips) - expenses
        }
        else {
            todaysEarnings = todaysTips
        }
        
        println("cupsSold = \(cupsSold)")
        println("todaysEarnings = \(todaysEarnings)")
        println("expenses = \(expenses)")
        println("todaysTips = \(todaysTips)")
        
        println("// resources.money = \(resources.money)")
        println("// resources.lemons = \(resources.lemons)")

        //resources.money = 1
        //resources.lemons = 0
        // check to see if the game is over gameStatus
        if resources.money <= 2 && resources.lemons == 0  {
            println("GAME OVER")
            gameStatus = "over"
        }
    }
    
    func calulateTip(customer: Customer) -> Float {
        
        var tipAmount : Float = 0
        
        if customer.tipsGood {
            tipAmount = Float(cupPrice) * 0.2
            println("Customer gave you a good tip")
        }
        else if customer.tipsBad {
            tipAmount = Float(cupPrice) * 0.1
            println("Customer gave you a bad tip")
        }
        else if customer.tipsNone {
            tipAmount = 0.0
            println("Customer did not gave you a tip")
        }
        
        return tipAmount
    }

    
    func pulseIcon(icon: UIImageView) {
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseOut | .BeginFromCurrentState, animations: {
            icon.transform = CGAffineTransformMakeScale(1.15, 1.15)
            }, completion: { finished in
                UIView.animateWithDuration(0.2, delay: 0.0, options: nil, animations: {
                    icon.transform = CGAffineTransformMakeScale(1.00, 1.00)
                    }, completion: { finished in
                        //
                })
        })
    }
    
    func updateHUDLabels() {
        moneyLabel.text = NSString(format:"$%.2f", Float(resources.money))
        lemonsLabel.text = "\(resources.lemons)"
        iceCubesLabel.text = "\(resources.iceCubes)"
    }
    
    func updateHUD() {
        daylabel.text = "\(currentDay)"
        
        moneyLabel.text = NSString(format:"$%.2f", Float(resources.money))
        lemonsLabel.text = "\(resources.lemons)"
        iceCubesLabel.text = "\(resources.iceCubes)"
        
        currentWeather.checkWeather()
        
        self.weatherImage.image = currentWeather.weatherIcon
        self.weatherLabel.text = "\(currentWeather.currentTemperature)°"
    }
    
    func updateStoreLabels() {
        storeLemonsSelected.text = "\(basket.lemons)"
        storeIceCubesSelected.text = "\(basket.iceCubes)"
        
        if basket.lemons <= 0 {
            storeLemonsMinusButton.enabled = true
        } else {
            storeLemonsMinusButton.enabled = false
        }
        
        if basket.lemons >= 0 {
            storeLemonsMinusButton.enabled = true
        } else {
            storeLemonsMinusButton.enabled = false
        }
        
        if basket.lemons == 0 {
            storeLemonsMinusButton.enabled = false
        } else {
            storeLemonsMinusButton.enabled = true
        }
        
        println("resources.money = \(resources.money)")
        println("lemonPrice = \(lemonPrice)")
        if resources.money < lemonPrice {
            storeLemonsPlusButton.enabled = false
        } else {
            storeLemonsPlusButton.enabled = true
        }
        
        
        
        
        if basket.iceCubes <= 0 {
            storeIceCubesMinusButton.enabled = true
        } else {
            storeIceCubesMinusButton.enabled = false
        }
        
        if basket.iceCubes >= 0 {
            storeIceCubesMinusButton.enabled = true
        } else {
            storeIceCubesMinusButton.enabled = false
        }
        
        if basket.iceCubes == 0 {
            storeIceCubesMinusButton.enabled = false
        } else {
            storeIceCubesMinusButton.enabled = true
        }
        
        if resources.money < iceCubesPrice {
            storeIceCubesPlusButton.enabled = false
        } else {
            storeIceCubesPlusButton.enabled = true
        }
    }
    
    func updateMixLabels() {
        mixLemonsSelected.text = "\(currentMix.lemons)"
        mixIceCubesSelected.text = "\(currentMix.iceCubes)"
        
        
        // Lemons
        if resources.lemons > 0 {
           mixLemonsPlusButton.enabled = true
        } else {
           mixLemonsPlusButton.enabled = false
        }
        
        if resources.lemons == currentMix.lemons {
            mixLemonsPlusButton.enabled = false
        } else {
            mixLemonsPlusButton.enabled = true
        }
        
        if resources.lemons == 0 && currentMix.lemons >= 0  {
            mixLemonsPlusButton.enabled = false
        } else {
            mixLemonsPlusButton.enabled = true
        }
        
        if currentMix.lemons > 0  {
            mixLemonsMinusButton.enabled = true
        } else {
            mixLemonsMinusButton.enabled = false
        }
        
        // Ice Cubes
        if resources.iceCubes > 0 {
            mixIceCubesPlusButton.enabled = true
        } else {
            mixIceCubesPlusButton.enabled = false
        }
        
        if resources.iceCubes == currentMix.iceCubes {
            mixIceCubesPlusButton.enabled = false
        } else {
            mixIceCubesPlusButton.enabled = true
        }
        
        if resources.iceCubes == 0 && currentMix.iceCubes >= 0  {
            mixIceCubesPlusButton.enabled = false
        } else {
            mixIceCubesPlusButton.enabled = true
        }
        
        if currentMix.iceCubes > 0  {
            mixIceCubesMinusButton.enabled = true
        } else {
            mixIceCubesMinusButton.enabled = false
        }
        
    }
    
    func setUpNewDay() {
        println("Setting up a new day")
        
        // Remove old customers
        customers.removeAll(keepCapacity: true)
        
        // Change day
        currentDay += 1
        totalCustomers = 0
        cupsSold = 0
        
        // Add todays earnings
        resources.money += todaysEarnings
        
        // clear todaysEarnings 
        todaysEarnings = 0
        
        // Reset supplies and mix
        basket.lemons = 0
        basket.iceCubes = 0
        currentMix.lemons = 0
        currentMix.iceCubes = 0
        
        updateStoreLabels()
        updateMixLabels()
        
        updateHUD()
    }
    
    
    func setUpNewGame() {
        println("Setting up a new game")
        gameStatus = "active"
        resources.setStartUpFunds()
        currentWeather.checkWeather()
        
        basket.lemons = 0
        basket.iceCubes = 0
        currentMix.lemons = 0
        currentMix.iceCubes = 0
        customers = []
        
        updateStoreLabels()
        updateMixLabels()
        updateHUD()
    }
}

