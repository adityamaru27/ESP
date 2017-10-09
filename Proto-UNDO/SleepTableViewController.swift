//
//  SleepTableViewController.swift
//  SleepMore
//
//  Created by Lee Xiaoxiao on 9/30/15.
//  Copyright © 2015 Lee Xiaoxiao All rights reserved.
//

import UIKit

class SleepTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource,   UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate  {
    
    
    @IBOutlet weak var labelParent: UILabel!
    let NVItemSaveColor:UIColor = UIColor(red:255.0/255.0, green:59.0/255.0, blue:48.0/255.0, alpha:1.0) // #FF3B30
    let NVItemDefaultColor:UIColor = UIColor(red:0.0/255.0, green:122.0/255.0, blue:255.0/255.0, alpha:1.0) // #007AFF
 
    
    //===============================================
    
    let NVItemStartColor:UIColor = UIColor(red:76.0/255.0, green:217.0/255.0, blue:100.0/255.0, alpha:1.0) // #4CD964
    let NVItemStopColor:UIColor = UIColor(red:255.0/255.0, green:149.0/255.0, blue:0.0/255.0, alpha:1.0) // #FF9500
    
    
    
    let NVItemResetActiveColor:UIColor = UIColor(red:3.0/255.0, green:122.0/255.0, blue:255.0/255.0, alpha:1.0) // #
    let NVItemResetDefaultColor:UIColor = UIColor(red:142.0/255.0, green:142.0/255.0, blue:142.0/255.0, alpha:1.0) // #8e8e8e
    //===============================================
    
    
    
    //===============================================
    
    var startTime = NSTimeInterval()
    
    var timer = NSTimer()
    
    @IBOutlet weak var btnResetStopWatch: UIButton!
    @IBOutlet weak var btnStartStopWatch: UIButton!
    
    //===============================================
    
    
    var mSelectedIndex: NSInteger! = -1
    
    var oldState = 0
    var settingData:SleepMoreSettingData = SleepMoreSettingData()
    var init_settingData:SleepMoreSettingData = SleepMoreSettingData()
    
    var bIsExpandedDuration:Bool = false
    
    // Activity Indicator
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    var bIsExpandTimePicker1:Bool = false
    
    var bIsExpandTimePicker2:Bool = false
    
    
    @IBOutlet weak var btnDelete: UIButton!
  
    
    
    @IBOutlet weak var imageCapture: UIImageView!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    //===============================================
    @IBOutlet weak var sleeptextinput: UITextField!
    var tblView: UITableView!
    
    var bItemChanged:Bool = false
    
    
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!

    
    @IBOutlet weak var lblDurationReady1: UILabel!
 
    
    @IBOutlet weak var lblTimeResult1: UILabel!
    
    @IBOutlet weak var lblTimeNotSet1: UILabel!
    
    @IBOutlet weak var lblTimeEdit1: UILabel!
    
    @IBOutlet weak var btnClearTime1: UIButton!
    
    
    @IBOutlet weak var vwNeededBorder1: UIView!
    
    @IBOutlet weak var vwNeededBorder2: UIView!

    
    
    //============================================
    
    @IBOutlet weak var datePicker1: UIDatePicker!


    func datePickerValueChanged1(sender: UIDatePicker)
    {
        refreshDatePicker1(true, date:datePicker1.date)
        settingData.timeFellAsleep = datePicker1.date
        
    }
    
    //===============================================
    
    @IBOutlet weak var lblTimeResult2: UILabel!
    
    @IBOutlet weak var lblTimeNotSet2: UILabel!
    
    @IBOutlet weak var lblTimeEdit2: UILabel!
    
    @IBOutlet weak var btnClearTime2: UIButton!
    
    
    //============================================
    
    @IBOutlet weak var lblDuration1: UILabel!
    
    @IBOutlet weak var lblPickerResult: UILabel!
    
    @IBOutlet weak var lblPickerNotSet1: UILabel!
    
    //============================================
    
    @IBOutlet weak var lblDuration2: UILabel!
    
    @IBOutlet weak var lblPickerNotSet2: UILabel!
    
    @IBOutlet weak var lblPickerEdit: UILabel!
    
    @IBOutlet weak var btnClearPicker: UIButton!
    
    //============================================
    
    @IBOutlet weak var pickerHours: UIPickerView!
    
    @IBOutlet weak var pickerMinutes: UIPickerView!
    
    //============================================

    @IBOutlet weak var datePicker2:UIDatePicker!
    
    //===============================================

    func datePickerValueChanged2(sender: UIDatePicker)
    {
        refreshDatePicker2(true, date:datePicker2.date)
        settingData.timeWokeUp = datePicker2.date
    }

    
    @IBAction func OnTappedClearTime1(sender: UIButton) {
       // refreshDatePicker1(false, date: initTime!)
        
        
        settingData.nDurationHours = 0
        settingData.nDurationMinutes = 0
        
        settingData.timeDuration = ""
        
        lblPickerEdit.text = settingData.timeDuration
        
        
        bIsExpandedDuration = false
        
        
        lblPickerNotSet1.hidden = false
        lblPickerResult.hidden = true
        
        
        pickerHours.selectRow(settingData.nDurationHours, inComponent: 0, animated: true)
        pickerMinutes.selectRow(settingData.nDurationMinutes, inComponent: 0, animated: true)
   
        
        tableView.reloadData()

        datePicker1.setDate(initTime!, animated: false)
        refreshDatePicker1(false, date: initTime!)

        
         checkItemChanged()
    }

    @IBAction func OnTappedClearTime2(sender: UIButton) {
        refreshDatePicker2(false, date: initTime!)
        datePicker2.setDate(initTime!, animated: false)
         checkItemChanged()
    }
    
    
    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = (self.view?.frame)!
        newImageView.backgroundColor = .blackColor()
        newImageView.contentMode = .ScaleAspectFit
        newImageView.userInteractionEnabled = true
        self.tableView.scrollRectToVisible(newImageView.frame, animated: true)
        let tap = UITapGestureRecognizer(target: self, action: #selector(PumpMoreVC.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }

    var initTime:NSDate?
    
    func isCorrect(start:NSDate, end:NSDate) -> Bool {
        let min:Int = NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: start, toDate: end, options: []).minute
        return min > 0
    }
    
    func isEqual(start:NSDate, end:NSDate) -> Bool {
        let second:Int = NSCalendar.currentCalendar().components(NSCalendarUnit.Second, fromDate: start, toDate: end, options: []).second
        return second == 0
    }
    
    func getDateDurationFormat(start:NSDate, end:NSDate) -> String {
        if(isEqual(start, end:initTime!) || isEqual(end, end:initTime!)){
            return "Auto Calulated"
        }
  
        var min:Int = NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: start, toDate: end, options: []).minute
        let day:Int = min/(60*24)
        let hour:Int = (min-(60*24)*day)/60
        min = min - (60 * 24)*day - 60 * hour
        if day>0{
            
            if hour == 0 && min == 0
            {
                return String(format: "%d d", day)
            }
            else if min == 0
            {
                 return String(format: "%d d, %d %@", day, hour, hour > 1 ? "hrs":"hr")
            }
            
            return String(format: "%d d, %d %@, %d %@", day, hour,hour > 1 ? "hrs":"hr", min, min > 1 ? "mins":"min")
            
        }else if hour>0{
            
            if min == 0
            {
                return String(format: "%d %@", hour, hour > 1 ? "hrs":"hr")
            }
            
            return String(format: "%d %@, %d %@", hour, hour > 1 ? "hrs":"hr", min,min > 1 ? "mins":"min")
            
            
        }else if min>0{
            return String(format: "%d %@", min,min > 1 ? "mins":"min")
        }else {
            return "Auto Calulated"
        }
    }
    
    func getDateFormat(selectedTime:NSDate) -> String
    {
        let dateFormatter = NSDateFormatter()
        var text : String = ""
        if NSCalendar.currentCalendar().isDateInToday(selectedTime) {
            dateFormatter.dateFormat = "h:mm a"
            text = "" + dateFormatter.stringFromDate(selectedTime)
        }else if NSCalendar.currentCalendar().isDateInTomorrow(selectedTime) {
            dateFormatter.dateFormat = "h:mm a"
            text = "Tomorrow " + dateFormatter.stringFromDate(selectedTime)
        }else if NSCalendar.currentCalendar().isDateInYesterday(selectedTime) {
            dateFormatter.dateFormat = "h:mm a"
            text = "Yesterday " + dateFormatter.stringFromDate(selectedTime)
        }else {
            dateFormatter.dateFormat = "MM-dd h:mm a"
            text = dateFormatter.stringFromDate(selectedTime)
        }
        return text
    }
    
    func refreshDatePicker1(isExpand:Bool, date:NSDate){
        if isExpand {
            if isEqual(date, end:initTime!) {
                lblTimeNotSet1.hidden = false
                lblTimeEdit1.hidden = true
                btnClearTime1.hidden = true
            }else{
                lblTimeNotSet1.hidden = true
                lblTimeEdit1.hidden = false
                btnClearTime1.hidden = false
                lblTimeEdit1.text = getDateFormat(date)
                datePicker1.setDate(date, animated: false)
            }
            lblTimeResult1.hidden = true
        }else{
            if isEqual(date, end:initTime!) || lblTimeEdit1.hidden {
                lblTimeNotSet1.hidden = false
                lblTimeResult1.hidden = true
                settingData.timeFellAsleep = initTime
                refreshDatePicker2(false, date:initTime!)
            }else{
                lblTimeNotSet1.hidden = true
                lblTimeResult1.hidden = false
                lblTimeResult1.text = getDateFormat(date)
                settingData.timeFellAsleep = date
            }
            //datePicker2.minimumDate = date
            lblTimeEdit1.hidden = true
            btnClearTime1.hidden = true
        }
        if !isCorrect(date, end: settingData.timeWokeUp!){
          //  datePicker2.minimumDate = date
          //  refreshDatePicker2(false, date:initTime!)
        }
        bIsExpandTimePicker1 = isExpand
        bIsExpandTimePicker2 = false
        
        
        settingData.timeDuration = getDateDurationFormat(settingData.timeFellAsleep!, end:settingData.timeWokeUp!)
        lblAutoCalculated.text = settingData.timeDuration
        
        tableView.reloadData()
    }
    
    func refreshDatePicker2(isExpand:Bool, date:NSDate){
        if isExpand {
            if isEqual(date, end:initTime!) {
                lblTimeNotSet2.hidden = false
                lblTimeEdit2.hidden = true
                btnClearTime2.hidden = true
            }else{
                lblTimeNotSet2.hidden = true
                lblTimeEdit2.hidden = false
                btnClearTime2.hidden = false
                lblTimeEdit2.text = getDateFormat(date)
                datePicker2.setDate(date, animated: false)
            }
            lblTimeResult2.hidden = true
        }else{
            if isEqual(date, end:initTime!) || lblTimeEdit2.hidden {
                lblTimeNotSet2.hidden = false
                lblTimeResult2.hidden = true
                settingData.timeWokeUp = initTime
            }else{
                lblTimeNotSet2.hidden = true
                lblTimeResult2.hidden = false
                lblTimeResult2.text = getDateFormat(date)
                settingData.timeWokeUp = date
            }
            lblTimeEdit2.hidden = true
            btnClearTime2.hidden = true
        }
        bIsExpandTimePicker2 = isExpand
        bIsExpandTimePicker1 = false
        settingData.timeDuration = getDateDurationFormat(settingData.timeFellAsleep!, end:date)
        lblAutoCalculated.text = settingData.timeDuration
        tableView.reloadData()
    }

    @IBOutlet weak var btnStar: UIButton!
    
    @IBOutlet weak var btnExclamation: UIButton!
    
    
    @IBOutlet weak var btnParent: UIButton!
  
    
    @IBOutlet weak var imgStar: UIImageView!
    
    @IBOutlet weak var imgExclamation: UIImageView!
    
    @IBAction func OnStarTapped(sender: UIButton) {
        SetStar(!settingData.bIsSelectedStar)
         checkItemChanged()
    }
    
    @IBAction func OnExclamationTapped(sender: UIButton) {
        SetExclamation(!settingData.bIsSelectedExclamation)
         checkItemChanged()
    }
    
    
    @IBAction func OnParentTapped(sender: AnyObject) {
        logEvent.parentMark = !logEvent.parentMark
        SetParent(logEvent.parentMark)
        
        checkItemChanged()
    }
    
    @IBAction func onClkTimerBtn(sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let timerVC = storyboard.instantiateViewControllerWithIdentifier("timerNavBar") as! UINavigationController
        presentViewController(timerVC, animated: true, completion: nil)
    }
    
    func SetParent(isSel:Bool)
    {
        let nonSelectedColor = UIColor(red:0.52, green:0.55, blue:0.60, alpha:1.0)
        let selectedColor = UIColor(red:1.0, green:176.0/255.0, blue:64.0/255.0, alpha:1.0)
        
        btnParent.tintColor = isSel ? selectedColor : nonSelectedColor
        
        labelParent.textColor =  isSel ? selectedColor : nonSelectedColor
        
        settingData.bIsSelectedParent = isSel
    }
    
    
    func SetStar(isSel:Bool) {
        if isSel {
            btnStar.setImage(UIImage(named: "star_background_a.png"), forState: UIControlState.Normal)
            imgStar.image=UIImage(named: "star_Large_a.png")
            
            SetExclamation(false)
        }else{
            btnStar.setImage(UIImage(named: "a.png"), forState: UIControlState.Normal)
            imgStar.image=UIImage(named: "star_Large.png")
        }
        settingData.bIsSelectedStar = isSel
    }
    
    func SetExclamation(isSel:Bool) {
        if isSel {
            btnExclamation.setImage(UIImage(named: "exclamation_background_a.png"), forState: UIControlState.Normal)
            imgExclamation.image=UIImage(named: "exclamation_Large_a.png")
            SetStar(false)
        }else{
            btnExclamation.setImage(UIImage(named: "a.png"), forState: UIControlState.Normal)
            imgExclamation.image=UIImage(named: "exclamation_Large.png")
        }
        settingData.bIsSelectedExclamation = isSel
    }
    
    
    @IBOutlet weak var lblAutoCalculated: UILabel!
    
    //===============================================
    
    @IBOutlet weak var swNotJustNow: UISwitch!
    
    @IBAction func OnChangedNotJustNow(sender: UISwitch) {
        settingData.bIsNotJustNow = sender.on
        if !sender.on {
            refreshDatePicker1(false, date: initTime!)
            refreshDatePicker2(false, date: initTime!)
        }
        bIsExpandTimePicker1 = false
        bIsExpandTimePicker2 = false
        self.tableView.reloadData()
         checkItemChanged()
    }
    
    
    @IBAction func onTapSave(sender: AnyObject) {
  
        
        if timer.valid
        {
            
            btnStartStopWatch.backgroundColor = NVItemStartColor
            btnStartStopWatch.setTitle("START", forState: UIControlState.Normal)
            btnStartStopWatch.tag  = 0
            
            timer.invalidate()
        }

        
        // save functions
        // Convert SettingData to LogEvent
        
        logEvent.bIsJustNow = settingData.bIsNotJustNow
        
        logEvent.starMark = settingData.bIsSelectedStar
        logEvent.exclamationMark = settingData.bIsSelectedExclamation
        logEvent.parentMark = settingData.bIsSelectedParent
        logEvent.image = settingData.sleepImage
        
        logEvent.timeFellAsleep = settingData.timeFellAsleep
        logEvent.timeWokeUp = settingData.timeWokeUp
        
        if settingData.timeDuration != "Auto Calulated"
        {
            logEvent.timeDuration =  settingData.timeDuration
        }
        else
        {
            logEvent.timeDuration =  nil
        }
        
        logEvent.leftHours = settingData.nDurationHours
        logEvent.leftMins = settingData.nDurationMinutes
        
      
        // Assign Text
        if let text = sleeptextinput.text {
            settingData.strNoteText = text
        }
        else {
            settingData.strNoteText = ""
        }
        logEvent.note = settingData.strNoteText
        
        // Add activity indicator
        activityIndicator.center = self.tableView.center
        activityIndicator.color = UIColor.redColor()
        tableView.addSubview(activityIndicator)
        
        // Save data to Parse
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
    if mSelectedIndex >= 0
    {
        DataSource.sharedDataSouce.updateEventWithIndex(mSelectedIndex, logEvent: logEvent)
        
        
        delay(1, closure: { () -> () in
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            self.activityIndicator.stopAnimating()
           // self.navigationController?.popToRootViewControllerAnimated(true)
        })
    }
    else
    {
        
        DataSource.sharedDataSouce.logEvent(self.logEvent, block: { (success, error) -> Void in
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            self.activityIndicator.stopAnimating()
            if (success){
                // self.changed = false
                self.navigationController?.popViewControllerAnimated(true)
            }
            else{
                let av = UIAlertView(title: "Error", message: "Error:\(error?.localizedDescription)", delegate: nil, cancelButtonTitle: "OK")
                av.show()
            }
        })
        
        }

        
    }
    
    func dismiss() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func onTapDelete(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Confirm", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (ACTION :UIAlertAction!) in
            
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
            DataSource.sharedDataSouce.deleteEventWithIndex(self.mSelectedIndex)
            //   self.activityIndicator.startAnimating()
            delay(1, closure: { () -> () in
                self.navigationController?.popToRootViewControllerAnimated(true)
            })
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    func checkItemChanged() {
        
        // check all any item changed
        bItemChanged = false
        
        repeat {
            let formatter : NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
       /*
            let timeFellAsleepInit = formatter.stringFromDate(init_settingData.timeFellAsleep!)
            let timeFellAsleepSetting = formatter.stringFromDate(settingData.timeFellAsleep!)
            if !timeFellAsleepSetting.isEqual(timeFellAsleepInit) {
                bItemChanged = true
                break
            }
    
            
            
            
            let timeWokeUpInit = formatter.stringFromDate(init_settingData.timeWokeUp!)
            let timeWokeUpSetting = formatter.stringFromDate(settingData.timeWokeUp!)
            if !timeWokeUpSetting.isEqual(timeWokeUpInit) {
                bItemChanged = true
                break
            }
*/

            if timer.valid || startTime > 0
            {
                bItemChanged = true
                break
            }

            
          /* if init_settingData.bIsNotJustNow != settingData.bIsNotJustNow {
                bItemChanged = true
                break
            }
            */
            
            if (( init_settingData.timeDuration != settingData.timeDuration ) && ( settingData.timeDuration != "Auto Calulated" ))
          {
            bItemChanged = true
            break
            }
        
            if init_settingData.bIsSelectedStar != settingData.bIsSelectedStar {
                bItemChanged = true
                break
            }
            
            if init_settingData.bIsSelectedExclamation != settingData.bIsSelectedExclamation {
                bItemChanged = true
                break
            }
            
            if init_settingData.bIsSelectedParent != settingData.bIsSelectedParent {
                bItemChanged = true
                break
            }

            
            if init_settingData.strNoteText != settingData.strNoteText {
                bItemChanged = true
                break
            }
            
            if init_settingData.sleepImage != settingData.sleepImage {
                bItemChanged = true
                break
            }
        } while false
        
        
        
        
        // Navigation Item change
        if bItemChanged {
            btnSave.tintColor = self.view.tintColor
            btnSave.enabled = true
            
            btnCancel.tintColor = NVItemSaveColor
        }
        else {
            btnSave.tintColor = NVItemDefaultColor
            btnSave.enabled = false
        }
    }
    
    
    
    
    @IBAction func onTapCancel(sender: AnyObject) {
   
        if mSelectedIndex >= 0
        {
            dismiss()
        }
        else
        {
        sleeptextinput.resignFirstResponder()
        if bItemChanged {
            let alertController = UIAlertController(title: nil, message: "Are you sure to \"Cancel\"?\nThe event will be deleted", preferredStyle: .ActionSheet)
            
            let deleteAction = UIAlertAction(title: "Yes, cancel and delete", style: .Destructive){ (action) in
                
                if self.timer.valid
                {
                    self.timer.invalidate()
                }
                self.navigationController?.popToRootViewControllerAnimated(true);
            }
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "No, don't delete", style: .Cancel){ (action) in
            }
            alertController.addAction(cancelAction)
            
            presentViewController(alertController, animated: true){}
        }
        else {
            dismiss()
        }
        }
    }
    
    var logEvent = LogEvent() {
        didSet {
            
            // convert LogEvent to PoopMoreSettingData
            
            logEvent.action = "slept"
            settingData.bIsNotJustNow = logEvent.bIsJustNow
           
            
            //settingData.timeDuration = logEvent.noteTime
            
            settingData.bIsSelectedStar = logEvent.starMark
            settingData.bIsSelectedExclamation = logEvent.exclamationMark
            settingData.bIsSelectedParent = logEvent.parentMark
            
            if logEvent.leftMins != nil && logEvent.leftHours != nil
            {
                settingData.nDurationMinutes    = logEvent.leftMins!
                settingData.nDurationHours = logEvent.leftHours!
            }
            
            if logEvent.timeFellAsleep != nil
            {
             settingData.timeFellAsleep = logEvent.timeFellAsleep
            }
            
            if logEvent.timeWokeUp != nil
            {
               settingData.timeWokeUp = logEvent.timeWokeUp
            }
            
            settingData.timeDuration =  logEvent.timeDuration
            
            
            init_settingData.timeFellAsleep = logEvent.timeFellAsleep
            init_settingData.timeWokeUp = logEvent.timeWokeUp
            init_settingData.timeDuration =  logEvent.timeDuration
            
            
            // TODO memo image
            settingData.sleepImage = nil     // ???
            
            
            // save initialize setting data
            init_settingData.bIsNotJustNow = settingData.bIsNotJustNow
            
            init_settingData.bIsSelectedParent = settingData.bIsSelectedParent
            
            init_settingData.bIsSelectedStar = settingData.bIsSelectedStar
            init_settingData.bIsSelectedExclamation = settingData.bIsSelectedExclamation
            init_settingData.strNoteText = settingData.strNoteText
            init_settingData.sleepImage = settingData.sleepImage
            
            
            init_settingData.timeFellAsleep = settingData.timeFellAsleep
            init_settingData.timeWokeUp = settingData.timeWokeUp
            init_settingData.timeDuration =  settingData.timeDuration
            
            
        }
    }

    
    
    
    func updateTime() {
        
        
        //Find the difference between current time and start time.
        
        startTime = startTime + 1
        
        var elapsedTime: NSTimeInterval =  startTime
        
        //calculate the minutes in elapsed time.
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= NSTimeInterval(seconds)
        
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        lblDurationReady1.text = "\(strMinutes):\(strSeconds)"
        
        
        if minutes < 60
        {
            settingData.nDurationHours = 0
            settingData.nDurationMinutes =  Int(minutes)
        }
        else
        {
            settingData.nDurationHours = Int(startTime / 3600.0)
            settingData.nDurationMinutes =  Int((startTime % 3600) / 60)
        }
        
        
        if minutes == 0  && seconds == 0
        {
            lblDurationReady1.textColor = NVItemResetDefaultColor
        }
        else
        {
                 lblDurationReady1.textColor = UIColor.blackColor()
        }
        
        
    }
    
    
    
    
    @IBAction func OnTappedDurationStart(sender: UIButton) {
        
        if sender.tag == 0
        {
            
            
            if lblPickerNotSet1.hidden {
                
                let alert = UIAlertController(title: "", message: "Please reset the Duration Picker to Not Set if you wish use the stopwatch", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
                
            }
            
            
            sender.backgroundColor = NVItemStopColor
            sender.setTitle("STOP", forState: UIControlState.Normal)
            sender.tag  = 1
            btnResetStopWatch.setTitleColor(NVItemResetActiveColor, forState: UIControlState.Normal)
            
            
            
            if !timer.valid {
                let aSelector : Selector = #selector(SleepTableViewController.updateTime)
                timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: aSelector,     userInfo: nil, repeats: true)
                
            }
            else
            {
                timer.fire()
            }
            
        }
        else
        {
            sender.backgroundColor = NVItemStartColor
            sender.setTitle("START", forState: UIControlState.Normal)
            sender.tag  = 0
            
            if timer.valid
            {
                timer.invalidate()
            }
        }
        
        
        // Marko
        checkItemChanged()
    }
    
    @IBAction func OnTappedDurationReset(sender: UIButton) {
        
        if timer.valid
        {
            
            btnStartStopWatch.backgroundColor = NVItemStartColor
            btnStartStopWatch.setTitle("START", forState: UIControlState.Normal)
            btnStartStopWatch.tag  = 0
            
            timer.invalidate()
        }
        
        startTime = -1
        updateTime()
        
        sender.setTitleColor(NVItemResetDefaultColor, forState: UIControlState.Normal)
        
        // Marko
        checkItemChanged()
    }

    
    
    
    
    
    
    
    func takePhoto(){
        getPicture(.Camera)
    }
    
    func getPicture(sourceType: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) == false
        {
            let alert = UIAlertView(title: "Camera", message: "Camera on your device is not available!", delegate: nil, cancelButtonTitle: "OK");
            alert.show()
            return
        }
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        picker.dismissViewControllerAnimated(true, completion: nil)
        let original = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageCapture.image = original
        
        //making it clickable
        self.imageCapture.userInteractionEnabled = true
        self.imageCapture.backgroundColor = UIColor.redColor()
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(PumpMoreVC.imageTapped(_:)))
        self.imageCapture.addGestureRecognizer(tapImage)

        
        
        
        if imageCapture.image != nil {
            
                
            settingData.sleepImage = imageCapture.image
            checkItemChanged()
            
            
            tableView.reloadData()
            
            if imageViewHeightConstraint.constant == 0 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.imageViewHeightConstraint.constant = 120
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                    
                    
                    
                })
            }
        }
    }
    
    
    func getExisting(){
        getPicture(.PhotoLibrary)
    }

    
    
    
    func getProMessagePopup()
    {
        let alertController = UIAlertController(title: nil, message: "To manage invites, upgrade to Eat Sleep Poop App Pro.\n", preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: "Upgrade to Pro", style: .Default){ (action) in
            
            
            let showESPProVC = UIStoryboard(name: "sleep", bundle: nil).instantiateViewControllerWithIdentifier("showESPProVC")
            
            let navController = UINavigationController(rootViewController: showESPProVC)
            
            
            self.presentViewController(navController, animated: true, completion: nil)
            
        }
        alertController.addAction(deleteAction)
        
        let resortAction = UIAlertAction(title: "Restore Pro", style: .Default){ (action) in
            
            
             MKStoreKit.sharedKit().restorePurchases()
            
        }
        alertController.addAction(resortAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel){ (action) in
        }
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true){}
        
    }

    
    @IBAction func actionTakePhoto(sender: AnyObject) {
        
        
        self.sleeptextinput.resignFirstResponder()
        
        
        
        
        if NSUserDefaults.standardUserDefaults().boolForKey("IS_VALID_USER") == false
        {
            if isTrailPeriod()
            {
            
            self.getProMessagePopup()
            return
            }
        }
        
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let photoAction = UIAlertAction(title: "Take a Photo", style:.Default){ (action) in self.takePhoto()}
        alertVC.addAction(photoAction)
        let chooseAction = UIAlertAction(title: "Choose Existing", style:.Default){ (action) in self.getExisting()}
        alertVC.addAction(chooseAction)
        let cancelAction = UIAlertAction(title: "Cancel", style:.Destructive){ (action) in}
        alertVC.addAction(cancelAction)
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        {
            alertVC.popoverPresentationController?.sourceView = self.view
            alertVC.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 49, 1.0, 1.0)
        }
        
        presentViewController(alertVC, animated: true, completion: nil)
    }
  
    
    
    func dataChanged()
    {
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        //===============================================
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(SleepTableViewController.dataChanged), name: kLogObjectUpdatedNotification, object: nil)
        
        startTime = 0
        
        btnStartStopWatch.layer.cornerRadius = 30
        btnStartStopWatch.backgroundColor = NVItemStartColor
        btnStartStopWatch.setTitle("START", forState: UIControlState.Normal)
        btnStartStopWatch.titleLabel?.font = UIFont(name: (btnStartStopWatch.titleLabel?.font.fontName)!, size: 16)
        
        btnResetStopWatch.titleLabel?.font = UIFont(name: (btnResetStopWatch.titleLabel?.font.fontName)!, size: 17)
        btnResetStopWatch.setTitleColor(NVItemResetDefaultColor, forState: UIControlState.Normal)
        
        lblDurationReady1.textColor = NVItemResetDefaultColor
        lblDurationReady1.font = UIFont(name: (lblDuration1.font.fontName), size: 36)
        
        
        //===============================================
        
        
       // settingData.bIsNotJustNow = false
      //  swNotJustNow.setOn(false, animated: false)
        
        pickerHours.delegate = self
        pickerHours.dataSource = self
        
        pickerMinutes.delegate = self
        pickerMinutes.dataSource = self
     
        
        
        let nonSelectedColor = UIColor(red:0.52, green:0.55, blue:0.60, alpha:1.0)
        btnParent.tintColor =  nonSelectedColor
        labelParent.textColor =  nonSelectedColor
        
        labelParent.font = UIFont.systemFontOfSize(14)
        
        vwNeededBorder1.layer.borderWidth = 0.5
        vwNeededBorder1.layer.borderColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0).CGColor
        
        vwNeededBorder2.layer.borderWidth = 0.5
        vwNeededBorder2.layer.borderColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0).CGColor
        
        
        self.imageViewHeightConstraint.constant = 120
        
        
        datePicker1.addTarget(self, action: #selector(SleepTableViewController.datePickerValueChanged1(_:)), forControlEvents: UIControlEvents.ValueChanged)

        datePicker2.addTarget(self, action: #selector(SleepTableViewController.datePickerValueChanged2(_:)), forControlEvents: UIControlEvents.ValueChanged)
  
        
        
        sleeptextinput.text = settingData.strNoteText;
        sleeptextinput.addTarget(self, action: #selector(SleepTableViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        sleeptextinput.delegate = self
        
        SetStar(settingData.bIsSelectedStar)
        SetExclamation(settingData.bIsSelectedExclamation)
        SetParent(settingData.bIsSelectedParent)
        
        swNotJustNow.setOn(settingData.bIsNotJustNow, animated: true)
        
        if  mSelectedIndex >= 0
        {
            
             self.title = String(format: "Sleep Edit");
            initTime = NSDate.init()
            
        if !settingData.bIsNotJustNow
        {
            
            if settingData.timeDuration != nil
            {
            if !lblPickerNotSet2.hidden {
                lblPickerNotSet2.hidden = true
            }
            
            lblPickerEdit.hidden = false
            btnClearPicker.hidden = false
           
            lblPickerEdit.text = settingData.timeDuration
        
            lblPickerNotSet1.hidden = true
            lblPickerResult.hidden = false

            lblPickerResult.text = settingData.timeDuration
        
            if logEvent.leftHours != nil && logEvent.leftMins != nil
            {
                pickerHours.selectRow(logEvent.leftHours!, inComponent: 0, animated: true)
                pickerMinutes.selectRow(logEvent.leftMins!, inComponent: 0, animated: true)
                
            }
            }
            
        }
        else
        {
            if settingData.timeDuration != nil
            {
            if logEvent.timeWokeUp != nil
            {
                lblTimeNotSet2.hidden = true
                lblTimeResult2.hidden = false
                lblTimeResult2.text = getDateFormat(logEvent.timeWokeUp!)
            }
            
            if logEvent.timeFellAsleep != nil
            {
                lblTimeNotSet1.hidden = true
                lblTimeResult1.hidden = false
                lblTimeResult1.text = getDateFormat(logEvent.timeFellAsleep!)
            }
            lblAutoCalculated.text = settingData.timeDuration
            }
        }
            checkItemChanged()
        }
        else
        {
            initTime = settingData.timeFellAsleep
            settingData.timeWokeUp = initTime
            
            
        }
       
        
        // Load Image from Parse
        logEvent.getImage{ (image: UIImage?, error : NSError?) -> Void in
            
            if image == nil || error != nil {
                
            }
            else {
                self.imageCapture.image = image!
                self.imageViewHeightConstraint.constant = 120
                self.view.layoutIfNeeded()
                self.tableView.reloadData()
            }
        }
        
        btnSave.enabled = false
        
        if mSelectedIndex >= 0
        {
            btnDelete.clipsToBounds = true
            btnDelete.layer.cornerRadius = 13
        }

        
        
       // addtextCell(2, textValue: "Stopwatch")
        //addtextCell(3, textValue: "Stopwatch")
       // addtextCell(10, textValue: "Timer")

    }
    
    
    
    
    func addtextCell(indexValue : Int, textValue : String )
    {
        
        
        let indexPath = NSIndexPath(forRow:indexValue, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        var labelTimer: UILabel = UILabel()
        labelTimer = UILabel(frame: CGRectMake(0, (cell?.frame.height)! - 25.0, self.view.frame.size.width, 20))
        
        labelTimer.textColor = UIColor(red: 133.0/255.0, green: 142.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        labelTimer.font = UIFont(name: "SFUIText-Regular", size: 11.0)
        labelTimer.text = textValue ;
        labelTimer.textAlignment = NSTextAlignment.Center
        
        cell!.addSubview(labelTimer)
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var hours = 0
        var minutes = 0
        
        if !settingData.bIsNotJustNow  {
            hours = pickerHours.selectedRowInComponent(0)
            minutes = pickerMinutes.selectedRowInComponent(0)
        }
        
        
        if oldState == hours + minutes {
            return row.description
        }
        oldState = hours + minutes
        
        if !settingData.bIsNotJustNow {
            if !lblPickerNotSet2.hidden {
                lblPickerNotSet2.hidden = true
            }
            lblPickerEdit.hidden = false
            btnClearPicker.hidden = false
            lblPickerEdit.text = getPickerFormat(hours, minutes: minutes)
            oldState = pickerHours.selectedRowInComponent(0) + pickerMinutes.selectedRowInComponent(0)
        }
        
        
        
        settingData.nDurationHours = hours
        settingData.nDurationMinutes = minutes
        
      /*  if hours > 0 && minutes > 0
        {
          settingData.timeDuration = String(format: "%d hr, %d min", hours, minutes)
        }
        else if hours > 0 && minutes == 0
        {
            settingData.timeDuration = String(format: "%d hr", hours)
        }
        else if hours == 0 && minutes >  0
        {
            settingData.timeDuration = String(format: "%d min", minutes)
        }
        */
        settingData.timeDuration = getPickerFormat(hours, minutes: minutes)
        
        lblPickerEdit.text = settingData.timeDuration
        
        checkItemChanged()
        
        
        return row.description
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

    
    
    // The number of columns of data
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    
    
    
    //===============================================
    
    
    
    //===================================================
    //      UITextField Delegate
    //===================================================
    
    func textFieldDidChange(textField: UITextField) {
        
        settingData.strNoteText = textField.text!
        checkItemChanged()
    }
    
    
    // UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    
    
    
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
 
        self.tblView = tableView;
        
        switch(indexPath.row)
        {
        case 1:
            return 45
            
        case 2:
            if settingData.bIsNotJustNow {
                return 0
            }
            else if bIsExpandedDuration {
                return 0
            }
            return 133

            
        case 3:
            if settingData.bIsNotJustNow {
                return 0
            }
            else if bIsExpandedDuration {
                return 270
            }
            return 0
            
        case 4:
            if settingData.bIsNotJustNow  {
                return 45
            }
             return 0
        case 5:
            if settingData.bIsNotJustNow && bIsExpandTimePicker1 {
                return 160
            }
            return 0
        case 6:
            if settingData.bIsNotJustNow  {
            return 45
            }
             return 0
        case 7:
            if settingData.bIsNotJustNow && bIsExpandTimePicker2 {
                return 160
            }
            return 0
        case 8:
             if settingData.bIsNotJustNow  {
            return 45
            }
            return 0
        case 10:
            return 96
        case 12:
            return 96
        case 14:
            return 96
        case 16:
            if self.imageCapture.image != nil {
                return 170
            }
            return 45
            
        case 17:
            if mSelectedIndex >= 0
            {
                return 20
            }
            return 70
            
        case 18:
            
            if mSelectedIndex >= 0
            {
                return 57
            }
            
            return 0
            
        case 19:
            if mSelectedIndex >= 0
            {
                return 300
            }
            return 0
            
        default:
            return 20
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if indexPath.row == 2 {
            
            
            if startTime > 0
            {
                let alert = UIAlertController(title: "", message: "Please reset the stopwatch to 00:00 if you wish enter Duration manually", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
                
            }
            
        }
        
        
        if indexPath.row == 2  {
            bIsExpandedDuration = true
            tableView.reloadData()
        }
        
        if indexPath.row == 3 {
            
            bIsExpandedDuration = false
            
            var hours = 0
            var minutes = 0
     
            hours = settingData.nDurationHours
            minutes = settingData.nDurationMinutes
            
            if hours + minutes == 0 {
                lblPickerNotSet1.hidden = false
                lblPickerResult.hidden = true
            }else{
                lblPickerNotSet1.hidden = true
                lblPickerResult.hidden = false
                lblPickerResult.text = getPickerFormat(hours, minutes: minutes)
            }
                
             tableView.reloadData()
            
            
        }
        
        if indexPath.row == 4 {
            if settingData.bIsNotJustNow && bIsExpandTimePicker1{
                refreshDatePicker1(false, date: datePicker1.date)
            }else{
                refreshDatePicker1(true, date: settingData.timeFellAsleep!)
            }
        }
        if indexPath.row == 6 {
            if settingData.bIsNotJustNow && !bIsExpandTimePicker1 && settingData.timeFellAsleep != initTime{
                if(bIsExpandTimePicker2){
                    refreshDatePicker2(false, date: datePicker2.date)
                }else{
                    refreshDatePicker2(true, date: settingData.timeWokeUp!)
                }
            }
            else
            { if(bIsExpandTimePicker2){
                refreshDatePicker2(false, date: datePicker2.date)
                }
                else
               {
                if(bIsExpandTimePicker1){
                 refreshDatePicker1(false, date: datePicker1.date)
                }
                 refreshDatePicker2(true, date: settingData.timeWokeUp!)
                }

                
            }
        }
        
        checkItemChanged()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
            
          //  switch indexPath.row {
          //  case 2,3,4,5,6:
            //    cell.separatorInset = UIEdgeInsets(top:0,left:15,bottom:0,right:0)
         //   default:
           //     return
          //  }
        }
    }
}
