//
//  SummaryViewController.swift
//  Proto-UNDO
//
//  Created by Santu C on 02/12/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit

class SummaryViewController: UITableViewController {

    var activityIndicator = UIActivityIndicatorView()
   
    
    /*************  EAT  ***************/
    @IBOutlet weak var lblEatTimes: UILabel!
    @IBOutlet weak var lblEatDuration: UILabel!
    
     /*************  Breast  ***************/
    @IBOutlet weak var lblBreastLeftTimes: UILabel!
    @IBOutlet weak var lblBreastLeftDuration: UILabel!
    
    @IBOutlet weak var lblBreastRightTimes: UILabel!
    @IBOutlet weak var lblBreastRightDuration: UILabel!
    
    @IBOutlet weak var lblBreastBothTimes: UILabel!
    @IBOutlet weak var lblBreastBothDuration: UILabel!
    
    @IBOutlet weak var lblBreastDuration: UILabel!
    
    
    /*************  Breast  ***************/
    
    /*************  Pump  ***************/
    
    @IBOutlet weak var lblPumpLeftTimes: UILabel!
    @IBOutlet weak var lblPumpLeftDuration: UILabel!
    
    @IBOutlet weak var lblPumpRightDuration: UILabel!
    @IBOutlet weak var lblPumpRightTimes: UILabel!
    
    
    @IBOutlet weak var lblPumpBothDuration: UILabel!
    @IBOutlet weak var lblPumpBothTimes: UILabel!
    
    @IBOutlet weak var lblPumpDuration: UILabel!
    
    /*************  Pump  ***************/
    
    /*************  Bottle  ***************/
    
    @IBOutlet weak var lblBottleTimes: UILabel!
    @IBOutlet weak var lblBottleQuantity: UILabel!
    @IBOutlet weak var lblBottleDuration: UILabel!
    
    /*************  Bottle  ***************/
    
    
     /*************  EAT  ***************/
    
    
    /*************  SLEEP  ***************/
    
    @IBOutlet weak var lblSleepTimes: UILabel!
    @IBOutlet weak var lblSleepDuration: UILabel!
    
    @IBOutlet weak var lblFellAsleepTimes: UILabel!
    
    @IBOutlet weak var lblWokeUpTimes: UILabel!

    @IBOutlet weak var lblSleptTimes: UILabel!
    
    /*************  SLEEP  ***************/
    
    /*************  Poop  ***************/
    @IBOutlet weak var lblPoopTimes: UILabel!
    @IBOutlet weak var lblPoopOnlyTimes: UILabel!
    @IBOutlet weak var lblPeesTimes: UILabel!
    
    /*************  Poop  ***************/

    
     /*************  Medicine  ***************/
    
    @IBOutlet weak var lblMedicineTimes: UILabel!
    @IBOutlet weak var lblMedicineOnlyTimes: UILabel!
    
     /*************  Medicine  ***************/
    
    /*************  Notes  ***************/
    @IBOutlet weak var lblNotesTimes: UILabel!
    @IBOutlet weak var lblNotesOnlyTimes: UILabel!
  
    
    /*************  Notes  ***************/
    
    
    
    
    var FilterOnEat : Bool = true
    var FilterOnSleep : Bool = true
    var FilterOnPoop : Bool = true
    var FilterOnMedicine : Bool = true
    var FilterOnNote : Bool = true
    
    
    var LastToday : Bool = false
    var Last24hours : Bool = false
    var Last2days : Bool = false
    var Last1week : Bool = false
    var Olderthan1week : Bool = false
    
    
    
    var FilterOnKey : Bool = true
    var FilterOnPerson : Bool = true
    var FilterOnStethoscope : Bool = true
    var FilterOnstar : Bool = true
    var FilterOnExclamation : Bool = true
    var FilterOnPicture : Bool = true
    
    
    
    
    
    
   
    
    override func viewWillAppear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(SummaryViewController.dataChanged), name: kLogObjectAddedNotification, object: nil)
        
        
        
        self.FilterOnEat = DataSource.sharedDataSouce.FilterOnEat
        self.FilterOnSleep = DataSource.sharedDataSouce.FilterOnSleep
        self.FilterOnPoop = DataSource.sharedDataSouce.FilterOnPoop
        self.FilterOnMedicine = DataSource.sharedDataSouce.FilterOnMedicine
        self.FilterOnNote = DataSource.sharedDataSouce.FilterOnNote
        
        self.LastToday = DataSource.sharedDataSouce.LastToday
        self.Last24hours = DataSource.sharedDataSouce.Last24hours
        self.Last2days = DataSource.sharedDataSouce.Last2days
        self.Last1week = DataSource.sharedDataSouce.Last1week
        self.Olderthan1week = DataSource.sharedDataSouce.Olderthan1week
        
        
        self.FilterOnKey = DataSource.sharedDataSouce.FilterOnKey
        self.FilterOnPerson = DataSource.sharedDataSouce.FilterOnPerson
        self.FilterOnStethoscope = DataSource.sharedDataSouce.FilterOnStethoscope
        self.FilterOnstar = DataSource.sharedDataSouce.FilterOnstar
        self.FilterOnExclamation = DataSource.sharedDataSouce.FilterOnExclamation
        self.FilterOnPicture = DataSource.sharedDataSouce.FilterOnPicture 
        

        
        DataSource.sharedDataSouce.FilterOnEat = true
        DataSource.sharedDataSouce.FilterOnSleep = true
        DataSource.sharedDataSouce.FilterOnPoop = true
        DataSource.sharedDataSouce.FilterOnMedicine = true
        DataSource.sharedDataSouce.FilterOnNote = true
        
        DataSource.sharedDataSouce.LastToday = true
        DataSource.sharedDataSouce.Last24hours = false
        DataSource.sharedDataSouce.Last2days = false
        DataSource.sharedDataSouce.Last1week = false
        DataSource.sharedDataSouce.Olderthan1week = false
        
        
        DataSource.sharedDataSouce.FilterOnKey = true
        DataSource.sharedDataSouce.FilterOnPerson = true
        DataSource.sharedDataSouce.FilterOnStethoscope = true
        DataSource.sharedDataSouce.FilterOnstar = true
        DataSource.sharedDataSouce.FilterOnExclamation = true
        DataSource.sharedDataSouce.FilterOnPicture = true
        
        
        
        
        if currentChild == nil
        {
            self.view.userInteractionEnabled = false
            self.navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "New Child Profile", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SummaryViewController.showNewChildProfile(_:)))
           // self.tableView.reloadData()
        }
        else
        {
            self.view.userInteractionEnabled = true
            DataSource.sharedDataSouce.reloadData()
            
            let firstname = currentChild["child_firstname"] as? String
            let lastname = currentChild["child_lastname"] as? String
            
            var child_fullname : String = firstname!
            if firstname != ""
            {
                child_fullname += " "
            }
            if lastname != ""
            {
                child_fullname += lastname!.substringToIndex(lastname!.startIndex.successor())
                child_fullname += "."
            }
            
            self.navigationItem.leftBarButtonItem =  UIBarButtonItem(title: child_fullname, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SummaryViewController.onPressChild(_:)))
            
            loadTodayData()
            
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        DataSource.sharedDataSouce.LastToday = false
        
        
        DataSource.sharedDataSouce.FilterOnEat = self.FilterOnEat
        DataSource.sharedDataSouce.FilterOnSleep = self.FilterOnSleep
        DataSource.sharedDataSouce.FilterOnPoop  = self.FilterOnPoop
        DataSource.sharedDataSouce.FilterOnMedicine = self.FilterOnMedicine
        DataSource.sharedDataSouce.FilterOnNote = self.FilterOnNote
        
        DataSource.sharedDataSouce.LastToday = self.LastToday
        DataSource.sharedDataSouce.Last24hours = self.Last24hours
        DataSource.sharedDataSouce.Last2days = self.Last2days
        DataSource.sharedDataSouce.Last1week = self.Last1week
        DataSource.sharedDataSouce.Olderthan1week = self.Olderthan1week
        
        
        DataSource.sharedDataSouce.FilterOnKey = self.FilterOnKey
        DataSource.sharedDataSouce.FilterOnPerson = self.FilterOnPerson
        DataSource.sharedDataSouce.FilterOnStethoscope = self.FilterOnStethoscope
        DataSource.sharedDataSouce.FilterOnstar = self.FilterOnstar
        DataSource.sharedDataSouce.FilterOnExclamation = self.FilterOnExclamation
        DataSource.sharedDataSouce.FilterOnPicture = self.FilterOnPicture
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.userInteractionEnabled = false
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 100, 100)) as UIActivityIndicatorView
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        initSetup()
        
        self.title = "Summary"
        // Do any additional setup after loading the view.
    }
    

    
    
    @IBAction func onPressChild(sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Child", bundle: nil)
        let childDetailVC = storyboard.instantiateViewControllerWithIdentifier("ChildDetailNavView")
        
        self.presentViewController(childDetailVC, animated: true, completion: nil)
    }
    
    func showNewChildProfile(sender : AnyObject?)
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let childVC = storyboard.instantiateViewControllerWithIdentifier("NewChildProfileView") as! NewChildProfileViewController
        childVC.isNewMoreChild = false
        let navVC = UINavigationController(rootViewController: childVC)
        
        self.presentViewController(navVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTodayData()
    {
        if currentChild != nil
        {
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            DataSource.sharedDataSouce.LastToday = true
            DataSource.sharedDataSouce.loadPageSize = 1000
            DataSource.sharedDataSouce.reloadData()
            
        }
    }
    
    
    
    func initSetup()
    {
        let eatTimesCount: Int = 0
        let breastLeftTimesCount: Int = 0
        let breastRightTimesCount: Int = 0
        let breastBothTimesCount: Int = 0
        let bottleTimesCount: Int = 0
        let pumpLeftTimesCount: Int = 0
        let pumpRightTimesCount: Int = 0
        let pumpBothTimesCount : Int = 0
        
        
        
        let eatDurationHours: Int = 0
        let eatDurationMins: Int = 0
        
        let breastLeftDurationHours: Int = 0
        let breastLeftDurationMins: Int = 0
        
        let breastRightDurationHours: Int = 0
        let breastRightDurationMins: Int = 0
        
        let breastBothDurationHours: Int = 0
        let breastBothDurationMins: Int = 0
        
        
        let pumpLeftQuantityCount: Int = 0
        let pumpRightQuantityCount: Int = 0
        let pumpBothQuantityCount: Int = 0
        let bottleQuantityCount: Int = 0
        
        
        
        let sleepTimesCount: Int = 0
        let fullasleepTimesCount: Int = 0
        let wakeupTimesCount: Int = 0
        let sleptTimesCount: Int = 0
        
        let sleepDurationHours: Int = 0
        let sleepDurationMins: Int = 0
        
        
        let poopTimesCount: Int = 0
        let poopOnlyTimesCount: Int = 0
        let peeOnlyTimesCount: Int = 0
        
        let medicineTimesCount: Int = 0
        let notesTimesCount: Int = 0
        
        lblEatTimes.text = gettimesString(eatTimesCount)
        lblBreastBothTimes.text =  gettimesString(breastBothTimesCount)
        lblBreastLeftTimes.text = gettimesString(breastLeftTimesCount)
        lblBreastRightTimes.text = gettimesString(breastRightTimesCount)
        lblPumpRightTimes.text = gettimesString(pumpRightTimesCount)
        lblPumpLeftTimes.text = gettimesString(pumpLeftTimesCount)
        lblPumpBothTimes.text = gettimesString(pumpBothTimesCount)
        lblBottleTimes.text = gettimesString(bottleTimesCount)
        
        
        lblSleepTimes.text = gettimesString(sleepTimesCount)
        lblFellAsleepTimes.text = gettimesString(fullasleepTimesCount)
        lblWokeUpTimes.text = gettimesString(wakeupTimesCount)
        lblSleptTimes.text = gettimesString(sleptTimesCount)
        
        lblPoopTimes.text = gettimesString(poopTimesCount)
        lblPoopOnlyTimes.text = gettimesString(poopOnlyTimesCount)
        lblPeesTimes.text = gettimesString(peeOnlyTimesCount)
        
        lblMedicineOnlyTimes.text = gettimesString(medicineTimesCount)
        lblMedicineTimes.text = gettimesString(medicineTimesCount)
        
        lblNotesOnlyTimes.text = gettimesString(notesTimesCount)
        lblNotesTimes.text = gettimesString(notesTimesCount)
        
        lblSleepDuration.text = getPickerFormat(sleepDurationHours, minutes: sleepDurationMins)
        
        
        lblEatDuration.text = getPickerFormat(eatDurationHours, minutes: eatDurationMins)
        
        
        lblBreastDuration.text = "\(gettimesString(breastBothTimesCount + breastLeftTimesCount + breastRightTimesCount)), \(getPickerFormat(breastRightDurationHours + breastLeftDurationHours + breastBothDurationHours, minutes: breastBothDurationMins +  breastLeftDurationMins + breastRightDurationMins))"
        
        
        
        var unit = "oz"
        
        if ((NSUserDefaults.standardUserDefaults().objectForKey("Measurements")?.isEqualToString("oz")) == true) {
            unit = "oz"
        }
        else
        {
            unit = "mL"
        }
        
        
        lblPumpDuration.text = "\(gettimesString(pumpRightTimesCount + pumpLeftTimesCount )), \(pumpLeftQuantityCount + pumpRightQuantityCount) \(unit)"
        
        lblBottleDuration.text = "\(gettimesString(bottleTimesCount )), \(bottleQuantityCount) \(unit)"
        
        
        lblBreastRightDuration.text = getPickerFormat(breastRightDurationHours, minutes: breastRightDurationMins)
        lblBreastLeftDuration.text = getPickerFormat(breastLeftDurationHours, minutes: breastLeftDurationMins)
        lblBreastBothDuration.text = getPickerFormat(breastBothDurationHours, minutes: breastBothDurationMins )
        
        
        lblPumpLeftDuration.text = "\(pumpLeftQuantityCount) \(unit)"
        lblPumpBothDuration.text = "\(pumpBothQuantityCount) \(unit)"
        lblPumpRightDuration.text = "\(pumpRightQuantityCount) \(unit)"
        lblBottleQuantity.text = "\(bottleQuantityCount) \(unit)"

    }
    
    

    @objc func dataChanged(){
        
     //   print(DataSource.sharedDataSouce.count())
        
        
        var eatTimesCount: Int = 0
        var breastLeftTimesCount: Int = 0
        var breastRightTimesCount: Int = 0
        var breastBothTimesCount: Int = 0
        var bottleTimesCount: Int = 0
        var pumpLeftTimesCount: Int = 0
        var pumpRightTimesCount: Int = 0
        var pumpBothTimesCount: Int = 0
        
        
        var eatDurationHours: Int = 0
        var eatDurationMins: Int = 0
        
        var breastLeftDurationHours: Int = 0
        var breastLeftDurationMins: Int = 0
        
        var breastRightDurationHours: Int = 0
        var breastRightDurationMins: Int = 0
        
        var breastBothDurationHours: Int = 0
        var breastBothDurationMins: Int = 0
        
        
        var pumpLeftQuantityCount: Int = 0
        var pumpRightQuantityCount: Int = 0
        var pumpBothQuantityCount: Int = 0
        var bottleQuantityCount: Int = 0
        
        
        
        var sleepTimesCount: Int = 0
        var fullasleepTimesCount: Int = 0
        var wakeupTimesCount: Int = 0
        var sleptTimesCount: Int = 0
        
        var sleepDurationHours: Int = 0
        var sleepDurationMins: Int = 0
        
        
        var poopTimesCount: Int = 0
        var poopOnlyTimesCount: Int = 0
        var peeOnlyTimesCount: Int = 0
        
        var medicineTimesCount: Int = 0
        var notesTimesCount: Int = 0

        
        
        if DataSource.sharedDataSouce.count() == 0
        {

            initSetup()
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            
            return
        }
        
        
        
        for i in 0 ... (DataSource.sharedDataSouce.count() - 1)
        {
            let event:LogEvent? = DataSource.sharedDataSouce.EventAtIndex(i)
            
            if event!.type.isEqualToString("breast")
            {
                eatTimesCount += 1
                if event!.action.isEqualToString("right") {
                    breastRightTimesCount += 1
                    
                    if event?.rightHours != nil
                    {
                        breastRightDurationHours = breastRightDurationHours + (event?.rightHours)!
                    }
                    
                    if event?.rightMins != nil
                    {
                        breastRightDurationMins = breastRightDurationMins + (event?.rightMins)!
                    }
                    
                    
                }
                else if event!.action.isEqualToString("left") {
                    breastLeftTimesCount += 1
                    
                    if event?.leftHours != nil
                    {
                        breastLeftDurationHours = breastLeftDurationHours + (event?.leftHours)!
                    }
                    if event?.leftMins != nil
                    {
                        breastLeftDurationMins = breastLeftDurationMins + (event?.leftMins)!
                    }
                    
                }
                else
                {
                    breastBothTimesCount += 1
                    
                    if event?.leftHours != nil
                    {
                        breastBothDurationHours = breastBothDurationHours + (event?.leftHours)!
                    }
                    if event?.leftMins != nil
                    {
                        breastBothDurationMins = breastBothDurationMins + (event?.leftMins)!
                    }
                    
                    
                    if event?.rightHours != nil
                    {
                        breastBothDurationHours = breastBothDurationHours + (event?.rightHours)!
                    }
                    
                    if event?.rightMins != nil
                    {
                        breastBothDurationMins = breastBothDurationMins + (event?.rightMins)!
                    }
                    
                }
                
            }
            else if  event!.type.isEqualToString("pump")
            {
                eatTimesCount += 1
                
                if event!.action.isEqualToString("right") {
                    pumpRightTimesCount += 1
                    pumpRightQuantityCount =  pumpRightQuantityCount + Int((event?.value)!)
                    
                    
                    if event?.rightHours != nil
                    {
                        eatDurationHours = eatDurationHours + (event?.rightHours)!
                    }
                    if event?.rightMins != nil
                    {
                        eatDurationMins = eatDurationMins + (event?.rightMins)!
                    }

                    
                }
                else if event!.action.isEqualToString("left") {
                    pumpLeftTimesCount += 1
                    pumpLeftQuantityCount =  pumpLeftQuantityCount + Int((event?.value)!)
                    
                    
                    if event?.leftHours != nil
                    {
                        eatDurationHours = eatDurationHours + (event?.leftHours)!
                    }
                    if event?.leftMins != nil
                    {
                        eatDurationMins = eatDurationMins + (event?.leftMins)!
                    }
                    
                }
                else if event!.action.isEqualToString("both") {
                    pumpBothTimesCount += 1
                    pumpBothQuantityCount =  pumpBothQuantityCount + Int((event?.value)!)
                    
                    
                    if event?.bothHours != nil
                    {
                        eatDurationHours = eatDurationHours + (event?.bothHours)!
                    }
                    if event?.bothMins != nil
                    {
                        eatDurationMins = eatDurationMins + (event?.bothMins)!
                    }
                    
                }
            }
            else if event!.type.isEqualToString("bottle")
            {
                eatTimesCount += 1
                bottleTimesCount += 1
                
                bottleQuantityCount =  bottleQuantityCount + Int((event?.value)!)
                
                if event?.leftHours != nil
                {
                    eatDurationHours = eatDurationHours + (event?.leftHours)!
                }
                if event?.leftMins != nil
                {
                    eatDurationMins = eatDurationMins + (event?.leftMins)!
                }

            }
            else if event!.action == "asleep"
            {
                sleepTimesCount += 1
                fullasleepTimesCount += 1
            }
            else if  event!.action == "wokeup"
            {
                sleepTimesCount += 1
                wakeupTimesCount += 1
            }
            else if event!.action == "slept"
            {
                sleepTimesCount += 1
                sleptTimesCount += 1
                
                if event?.leftHours != nil
                {
                    sleepDurationHours = sleepDurationHours + (event?.leftHours)!
                }
                if event?.leftMins != nil
                {
                    sleepDurationMins = sleepDurationMins + (event?.leftMins)!
                    
                    if ( sleepDurationMins > 59)
                    {
                        let value = sleepDurationMins / 60
                       sleepDurationHours = sleepDurationHours + value
                        sleepDurationMins = sleepDurationMins - (sleepDurationMins * value)
                    }
                }
            }
            else if event!.type.isEqualToString("poop")
            {
                poopTimesCount += 1
                poopOnlyTimesCount += 1
            }
            else if event!.type.isEqualToString("pee")
            {
                 poopTimesCount += 1
                 peeOnlyTimesCount += 1
            }
            else if event!.type.isEqualToString("medicine")
            {
                medicineTimesCount += 1
            }
            else if event!.type.isEqualToString("note")
            {
                notesTimesCount += 1
            }

            

        }
        
        
        eatDurationHours = eatDurationHours + breastRightDurationHours + breastLeftDurationHours + breastBothDurationHours
        
        eatDurationMins = breastBothDurationMins +  breastLeftDurationMins + breastRightDurationMins
        
        lblEatTimes.text = gettimesString(eatTimesCount)
        lblBreastBothTimes.text =  gettimesString(breastBothTimesCount)
        lblBreastLeftTimes.text = gettimesString(breastLeftTimesCount)
        lblBreastRightTimes.text = gettimesString(breastRightTimesCount)
        lblPumpRightTimes.text = gettimesString(pumpRightTimesCount)
        lblPumpLeftTimes.text = gettimesString(pumpLeftTimesCount)
        lblPumpBothTimes.text = gettimesString(pumpBothTimesCount)
        lblBottleTimes.text = gettimesString(bottleTimesCount)
        
        
        lblSleepTimes.text = gettimesString(sleepTimesCount)
        lblFellAsleepTimes.text = gettimesString(fullasleepTimesCount)
        lblWokeUpTimes.text = gettimesString(wakeupTimesCount)
        lblSleptTimes.text = gettimesString(sleptTimesCount)
        
        lblPoopTimes.text = gettimesString(poopTimesCount)
        lblPoopOnlyTimes.text = gettimesString(poopOnlyTimesCount)
        lblPeesTimes.text = gettimesString(peeOnlyTimesCount)
        
        lblMedicineOnlyTimes.text = gettimesString(medicineTimesCount)
        lblMedicineTimes.text = gettimesString(medicineTimesCount)
        
        lblNotesOnlyTimes.text = gettimesString(notesTimesCount)
        lblNotesTimes.text = gettimesString(notesTimesCount)
        
        lblSleepDuration.text = getPickerFormat(sleepDurationHours, minutes: sleepDurationMins)
        
        
        lblEatDuration.text = getPickerFormat(eatDurationHours, minutes: eatDurationMins)
        
        
        lblBreastDuration.text = "\(gettimesString(breastBothTimesCount + breastLeftTimesCount + breastRightTimesCount)), \(getPickerFormat(breastRightDurationHours + breastLeftDurationHours + breastBothDurationHours, minutes: breastBothDurationMins +  breastLeftDurationMins + breastRightDurationMins))"
        
        var unit = "oz"
        
        if ((NSUserDefaults.standardUserDefaults().objectForKey("Measurements")?.isEqualToString("oz")) == true) {
            unit = "oz"
        }
        else
        {
            unit = "mL"
        }
        
        lblPumpDuration.text = "\(gettimesString(pumpRightTimesCount + pumpLeftTimesCount  + pumpBothTimesCount)), \(pumpLeftQuantityCount + pumpRightQuantityCount + pumpBothQuantityCount) \(unit)"
        
        lblBottleDuration.text = "\(gettimesString(bottleTimesCount )), \(bottleQuantityCount) \(unit)"

        
        lblBreastRightDuration.text = getPickerFormat(breastRightDurationHours, minutes: breastRightDurationMins)
        lblBreastLeftDuration.text = getPickerFormat(breastLeftDurationHours, minutes: breastLeftDurationMins)
        lblBreastBothDuration.text = getPickerFormat(breastBothDurationHours, minutes: breastBothDurationMins )
        
        
        lblPumpLeftDuration.text = "\(pumpLeftQuantityCount) \(unit)"
        lblPumpBothDuration.text = "\(pumpBothQuantityCount) \(unit)"
        lblPumpRightDuration.text = "\(pumpRightQuantityCount) \(unit)"
        lblBottleQuantity.text = "\(bottleQuantityCount) \(unit)"
        
        
         activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
       
       
        
    }
    
    
    
    func getPickerFormat(hours:Int,minutes:Int) -> String{
        var text:String = "0 min"
        
        if hours > 0 {
            text = String(format:"%d %@ %d %@",hours,hours > 1 ? "hrs":"hr" ,minutes, minutes > 1 ? "mins":"min")
        }else if minutes>0{
            text = String(format:"%d %@",minutes,minutes > 1 ? "mins":"min" )
        }else{
            text = "0 min"
        }
        return text
    }
    
    
    func gettimesString(valueInt: Int )-> String
    {
        if valueInt > 1
        {
            return "\(valueInt) times"
        }
        
        return "\(valueInt) time"
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
