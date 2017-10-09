//
//  BottleMoreVC.swift
//  Proto-UNDO
//
//  Created by Pankaj Chhikara on 30/10/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit

enum kBottleContentCell : Int {
    case SeperateStart = 0
    case NotNustNow         // 1
    
    case TimeBoth           // 2
    case DateTimePicker
    case QualityBottleSlider
    
    case LeftRight  // 4
    case DurationNoExpand   // 5
    case DurationExpand     // 6
    case DurationNoExpandNotJustNow     // 7
    case DurationExpandNotJustNow       // 8
    case SeperateBell       // 9
    case Bell               // 10
    case SeperateTag        // 11
    case StarOrExclamation  // 12
    case SeperateNotePhoto  // 13
    case Camera             // 14
    case SeperateEnd        // 15
}
class BottleMoreVC: UITableViewController ,  UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    
    let NVItemSaveColor:UIColor = UIColor(red:255.0/255.0, green:59.0/255.0, blue:48.0/255.0, alpha:1.0) // #FF3B30
    let NVItemDefaultColor:UIColor = UIColor(red:0.0/255.0, green:122.0/255.0, blue:255.0/255.0, alpha:1.0) // #007AFF
    
    var settingData:BottleMoreSettingData = BottleMoreSettingData()
    var bIsVisibleTimePicker:Bool = false
    var bIsExpandedDuration:Bool = false
    
    var oldState = 0
    var initTime:NSDate?
    
    
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

    
    
    
    var bItemChanged:Bool = false
    var init_settingData:BottleMoreSettingData = BottleMoreSettingData()
    
    // Activity Indicator
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
   
    @IBOutlet weak var lblQuantityPump: UILabel!
    
    
    @IBOutlet weak var lblQuantityBottle: UILabel!
    @IBOutlet weak var sliderQuantityBottle: UISlider!
    //===============================================
    
    @IBOutlet weak var lblTimeBothText: UILabel!
    
    @IBOutlet weak var lblTimeResult: UILabel!
    
    @IBOutlet weak var lblTimeNotSet: UILabel!
    
    @IBOutlet weak var lblTimeEdit: UILabel!
    
    @IBOutlet weak var btnClearTime: UIButton!
    
    //============================================
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
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
    
    @IBOutlet weak var btnStar: UIButton!
    
    @IBOutlet weak var btnExclamation: UIButton!
    
    @IBOutlet weak var imgStar: UIImageView!
    
    @IBOutlet weak var imgExclamation: UIImageView!
    
    @IBOutlet weak var lblDurationInfo1: UILabel!
    
    @IBOutlet weak var lblDurationInfo2: UILabel!
    
    @IBOutlet weak var swNotJustNow: UISwitch!
    
    @IBOutlet weak var lblDurationReady1: UILabel!
    
    @IBOutlet weak var lblDurationReady2: UILabel!
    
    @IBOutlet weak var vwNeededBorder1: UIView!
    
    @IBOutlet weak var vwNeededBorder2: UIView!
    
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var breastTextInput: UITextField!
    @IBOutlet weak var breastImageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    
    //============================================
    
    @IBOutlet weak var lblDurationJust: UILabel!
    
    @IBOutlet weak var lblPickerResultJust: UILabel!
    
    @IBOutlet weak var lblPickerNotSetJust: UILabel!
    
    //============================================
    
    @IBOutlet weak var lblDurationJustExpand: UILabel!
    
    @IBOutlet weak var lblPickerNotSetJustExpand: UILabel!
    
    @IBOutlet weak var lblPickerEditJustExpand: UILabel!
    
    @IBOutlet weak var btnClearPickerJustExpand: UIButton!
    
    //============================================
    
    @IBOutlet weak var pickerHoursJust: UIPickerView!
    
    @IBOutlet weak var pickerMinutesJust: UIPickerView!
    
    @IBOutlet weak var vwNeededBorder3: UIView!
    
    //===============================================
    
    
    @IBOutlet weak private var descriptionLabel: UILabel!
    
    @IBOutlet weak private var valueLabel: UILabel!
    
    @IBOutlet weak var txtQty: UITextField!
  
    //===============================================
  
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
    
    
    
    
    @IBAction func onClkTimerBtn(sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let timerVC = storyboard.instantiateViewControllerWithIdentifier("timerNavBar") as! UINavigationController
        presentViewController(timerVC, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //===============================================
        
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
        
        pickerHours.delegate = self
        pickerHours.dataSource = self
        
        pickerMinutes.delegate = self
        pickerMinutes.dataSource = self
        
        initTime = settingData.timeLeft
        //settingData.timeRight = initTime
        
        datePicker.addTarget(self, action: #selector(BottleMoreVC.datePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        vwNeededBorder1.layer.borderWidth = 0.5
        vwNeededBorder1.layer.borderColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0).CGColor
        
        vwNeededBorder2.layer.borderWidth = 0.5
        vwNeededBorder2.layer.borderColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0).CGColor
        
        // by Marko
        // Update UIs according the settings Data
        
        initBottleUIs()
        
        pickerHoursJust.delegate = self
        pickerHoursJust.dataSource = self
        
        pickerMinutesJust.delegate = self
        pickerMinutesJust.dataSource = self
        
        vwNeededBorder3.layer.borderWidth = 0.5
        vwNeededBorder3.layer.borderColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0).CGColor
        
        breastTextInput.text = settingData.strNoteText;
        breastTextInput.addTarget(self, action: #selector(BottleMoreVC.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        breastTextInput.delegate = self
        
        SetStar(settingData.bIsSelectedStar)
        SetExclamation(settingData.bIsSelectedExclamation)
        
        // Load Image from Parse
        logEvent.getImage{ (image: UIImage?, error : NSError?) -> Void in
            
            if image == nil || error != nil {
                
            }
            else {
                self.breastImageView.image = image!
                self.imageViewHeightConstraint.constant = 120
                self.view.layoutIfNeeded()
                self.tableView.reloadData()
            }
        }
        
        btnSave.enabled = false
        
        
        addtextCell(6, textValue: "Stopwatch")
        addtextCell(7, textValue: "Stopwatch")
        addtextCell(11, textValue: "Timer")
        
        
        
        
       // valueLabel.font = UIFont(name: "SFUIText-Regular", size: 17.0)
        descriptionLabel.font = UIFont(name: "SFUIText-Regular", size: 17.0)
        
        self.txtQty.delegate = self
        self.txtQty.tag = 1001
        
        
        let keyboardDoneButtonView = UIToolbar.init()
        keyboardDoneButtonView.sizeToFit()
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Done,
                                              target: self,
                                              action: Selector("doneClicked:"))
        
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Cancel,
                                                target: self,
                                                action: Selector("cancelClicked:"))
        
        keyboardDoneButtonView.items = [cancelButton,flexibleSpace, doneButton]
        txtQty.inputAccessoryView = keyboardDoneButtonView
        
        
        
       // let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
      //  view.addGestureRecognizer(tap)
        
        
        if ((NSUserDefaults.standardUserDefaults().objectForKey("Measurements")?.isEqualToString("oz")) == true) {
            valueLabel.text = "oz"
        }
        else
        {
            valueLabel.text = "mL"
        }

    }
    
    
    func dismissKeyboard() {
      
        view.endEditing(true)
    }
    
    
    func doneClicked(sender: AnyObject) {
        self.view.endEditing(true)
        
       
        
    }
    
    func cancelClicked(sender: AnyObject) {
        self.view.endEditing(true)
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
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - View life cycle
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden=false
    }
    
    //===============================================
    
    @IBAction func OnTappedClearTime(sender: UIButton) {
        //if bIsLeft{
            settingData.timeLeft = initTime
       // }
        refreshDatePicker(false)
        refreshViews()
        
        // Marko
        checkItemChanged()
    }
    
    @IBAction func OnTappedClearPicker(sender: UIButton) {
       // if bIsLeft{
            settingData.nLeftDurationHours = 0
            settingData.nLeftDurationMinutes = 0
        
        
        //}
        refreshViewPicker(false)
        refreshViews()
        
        // Marko
        checkItemChanged()
    }
    
    
    @IBAction func OnStarTapped(sender: UIButton) {
        SetStar(!settingData.bIsSelectedStar)
        
        // Marko
        checkItemChanged()
    }
    
    @IBAction func OnExclamationTapped(sender: UIButton) {
        SetExclamation(!settingData.bIsSelectedExclamation)
        
        // Marko
        checkItemChanged()
    }
    
    @IBAction func OnChangedNotJustNow(sender: UISwitch) {
        settingData.bIsNotJustNow = sender.on
        if !sender.on {
            
            settingData.timeLeft = initTime
            
            refreshDatePicker(false)
        }
        else {
            refreshDatePicker(true)
        }
        
        refreshViews()
        
        // Marko
        checkItemChanged()
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
            settingData.nLeftDurationHours = 0
            settingData.nLeftDurationMinutes =  Int(minutes)
            
        }
        else
        {
            settingData.nLeftDurationHours = Int(startTime / 3600.0)
            settingData.nLeftDurationMinutes =  Int((startTime % 3600) / 60)
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
            
            lblDurationReady1.textColor = UIColor.blackColor()
            
            sender.backgroundColor = NVItemStopColor
            sender.setTitle("STOP", forState: UIControlState.Normal)
            sender.tag  = 1
            btnResetStopWatch.setTitleColor(NVItemResetActiveColor, forState: UIControlState.Normal)
            
            
            
                if !timer.valid {
                    let aSelector : Selector = #selector(BottleMoreVC.updateTime)
                    timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: aSelector,     userInfo: nil, repeats: true)
                    
                }
                else
               {
                    timer.fire()
                }

        }
        else
        {
            lblDurationReady1.textColor = UIColor.blackColor()
            
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
    
         lblDurationReady1.textColor = NVItemResetDefaultColor
        
       sender.setTitleColor(NVItemResetDefaultColor, forState: UIControlState.Normal)
        
        // Marko
        checkItemChanged()
    }
    
    
    @IBAction func OnTappedDurationOR1(sender: UIButton) {
        bIsExpandedDuration = true
        self.tableView.reloadData()
        
        // Marko
        checkItemChanged()
    }
    
    @IBAction func OnTappedDurationOR2(sender: UIButton) {
        bIsExpandedDuration = false
        self.tableView.reloadData()
        
        // Marko
        checkItemChanged()
    }
    
    
    @IBAction func onTapCancel(sender: AnyObject) {
        
        breastTextInput.resignFirstResponder()
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
    
    @IBAction func onTapSave(sender: AnyObject) {
        
        if timer.valid
        {
            
            btnStartStopWatch.backgroundColor = NVItemStartColor
            btnStartStopWatch.setTitle("START", forState: UIControlState.Normal)
            btnStartStopWatch.tag  = 0
            
            timer.invalidate()
        }

        
        if ( settingData.bIsNotJustNow)
        {
            logEvent.time = datePicker.date.timeIntervalSinceReferenceDate
        }
        
        // save functions
        // Convert SettingData to LogEvent
        
        logEvent.bIsJustNow = settingData.bIsNotJustNow
        logEvent.displayDesc = settingData.bDisplayDescription
        logEvent.timeLeft = settingData.timeLeft
        
        
        logEvent.leftHours = settingData.nLeftDurationHours
        logEvent.leftMins = settingData.nLeftDurationMinutes
        
        logEvent.value = Float(txtQty.text!)!
        
        logEvent.starMark = settingData.bIsSelectedStar
        logEvent.exclamationMark = settingData.bIsSelectedExclamation
        logEvent.image = settingData.bottleImage
        // Assign Text
        if let text = breastTextInput.text {
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

    
    
    @IBAction func onTapCamera(sender: AnyObject) {
        
        breastTextInput.resignFirstResponder()
        
        
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
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if ( textField.tag == 1001 )
        {
            if ( textField.text?.characters.count > 0 )
            {
            logEvent.value = Float(textField.text!)!
            
            bItemChanged = true
            btnSave.enabled = true
            btnCancel.tintColor = NVItemSaveColor
            btnSave.tintColor = self.view.tintColor
            }
        }
        
    }
    
    
    @IBAction func OnSliderQuatityValueChanged(sender: UISlider) {
        lblQuantityBottle.text = "\(Int(sender.value)) oz"
        lblQuantityBottle.textColor = UIColor.blackColor()
        logEvent.value = sender.value;
        
         bItemChanged = true
         btnSave.enabled = true
         btnCancel.tintColor = NVItemSaveColor
         btnSave.tintColor = self.view.tintColor
    }
    
    
    //===============================================
    
    
    
    func datePickerValueChanged(sender: UIDatePicker)
    {
        if !lblTimeNotSet.hidden {
            lblTimeNotSet.hidden = true
            lblTimeEdit.hidden = false
            btnClearTime.hidden = false
        }
        lblTimeEdit.text = getDateFormat(datePicker.date)
        
        settingData.timeLeft = datePicker.date
        
       // logEvent.time = datePicker.date.timeIntervalSinceReferenceDate
        
        checkItemChanged()
    }
    
    func getDateFormat(selectedTime:NSDate) -> String
    {
        let dateFormatter = NSDateFormatter()
        var text : String = ""
        if NSCalendar.currentCalendar().isDateInToday(selectedTime) {
            dateFormatter.dateFormat = "h:mm a"
            text = "" + dateFormatter.stringFromDate(selectedTime).lowercaseString
        }else if NSCalendar.currentCalendar().isDateInTomorrow(selectedTime) {
            dateFormatter.dateFormat = "h:mm a"
            text = "Tomorrow " + dateFormatter.stringFromDate(selectedTime).lowercaseString
        }else if NSCalendar.currentCalendar().isDateInYesterday(selectedTime) {
            dateFormatter.dateFormat = "h:mm a"
            text = "Yesterday " + dateFormatter.stringFromDate(selectedTime).lowercaseString
        }else {
            dateFormatter.dateFormat = "MM/dd/yy h:mm a"
            text = dateFormatter.stringFromDate(selectedTime).lowercaseString
        }
        return text
    }
    
    
    func getPickerFormat(hours:Int,minutes:Int) -> String{
        var text:String = "0 min"
        
        if hours > 0 {
            
          text = String(format:"%d %@ %d %@",hours,hours > 1 ? "hrs":"hr" ,minutes ,minutes > 1 ? "mins":"min")
            
        }else if minutes>0{
            text = String(format:"%d %@",minutes,minutes > 1 ? "mins":"min")
        }else{
            text = "0 min"
        }
        return text
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var hours = 0
        var minutes = 0
        
        if settingData.bIsNotJustNow {
            hours = pickerHoursJust.selectedRowInComponent(0)
            minutes = pickerMinutesJust.selectedRowInComponent(0)
        }
        else {
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
        else {
            if !lblPickerNotSetJustExpand.hidden {
                lblPickerNotSetJustExpand.hidden = true
            }
            lblPickerEditJustExpand.hidden = false
            btnClearPickerJustExpand.hidden = false
            lblPickerEditJustExpand.text = getPickerFormat(hours, minutes: minutes)
            oldState = pickerHoursJust.selectedRowInComponent(0) + pickerMinutesJust.selectedRowInComponent(0)
        }
        
        
        
        
            settingData.nLeftDurationHours = hours
            settingData.nLeftDurationMinutes = minutes
        
        checkItemChanged()
        
        
        return row.description
    }
    
    
    
    func SetStar(isSel:Bool) {
        if isSel {
            btnStar.setImage(UIImage(named: "star_background_a.png"), forState: UIControlState.Normal)
            imgStar.image=UIImage(named: "star_Large_a.png")
            1
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
    
    func refreshDatePicker(isExpand:Bool){
        var t = initTime
       
            t = settingData.timeLeft!
       
        if isExpand {
            if t == initTime {
                lblTimeNotSet.hidden = false
                lblTimeEdit.hidden = true
                btnClearTime.hidden = true
            }else{
                lblTimeNotSet.hidden = true
                lblTimeEdit.hidden = false
                btnClearTime.hidden = false
                lblTimeEdit.text = getDateFormat(t!)
            }
            lblTimeResult.hidden = true
        }else{
            if t == initTime {
                lblTimeNotSet.hidden = false
                lblTimeResult.hidden = true
            }else{
                lblTimeNotSet.hidden = true
                lblTimeResult.hidden = false
                lblTimeResult.text = getDateFormat(t!)
            }
            lblTimeEdit.hidden = true
            btnClearTime.hidden = true
        }
        
        datePicker.setDate(t!, animated: true)
        bIsVisibleTimePicker = isExpand
    }
    
    func refreshViewPicker(isExpand:Bool){
        var hours = 0
        var minutes = 0
        
            hours = settingData.nLeftDurationHours
            minutes = settingData.nLeftDurationMinutes
    
        
        if !settingData.bIsNotJustNow {
            if isExpand {
                if hours + minutes == 0 {
                    lblPickerNotSet2.hidden = false
                    lblPickerEdit.hidden = true
                    btnClearPicker.hidden = true
                }else{
                    lblPickerNotSet2.hidden = true
                    lblPickerEdit.hidden = false
                    btnClearPicker.hidden = false
                    lblPickerEdit.text = getPickerFormat(hours, minutes: minutes)
                }
            }else{
                if hours + minutes == 0 {
                    lblPickerNotSet1.hidden = false
                    lblPickerResult.hidden = true
                }else{
                    lblPickerNotSet1.hidden = true
                    lblPickerResult.hidden = false
                    lblPickerResult.text = getPickerFormat(hours, minutes: minutes)
                }
            }
            pickerHours.selectRow(hours, inComponent: 0, animated: true)
            pickerMinutes.selectRow(minutes, inComponent: 0, animated: true)
        }
        else {
            // Marko
            
            if isExpand {
                if hours + minutes == 0 {
                    lblPickerNotSetJustExpand.hidden = false
                    lblPickerEditJustExpand.hidden = true
                    btnClearPickerJustExpand.hidden = true
                }else{
                    lblPickerNotSetJustExpand.hidden = true
                    lblPickerEditJustExpand.hidden = false
                    btnClearPickerJustExpand.hidden = false
                    lblPickerEditJustExpand.text = getPickerFormat(hours, minutes: minutes)
                }
            }else{
                if hours + minutes == 0 {
                    lblPickerNotSetJust.hidden = false
                    lblPickerResultJust.hidden = true
                }else{
                    lblPickerNotSetJust.hidden = true
                    lblPickerResultJust.hidden = false
                    lblPickerResultJust.text = getPickerFormat(hours, minutes: minutes)
                }
            }
            pickerHoursJust.selectRow(hours, inComponent: 0, animated: true)
            pickerMinutesJust.selectRow(minutes, inComponent: 0, animated: true)
        }
        
        
        oldState = hours + minutes
        bIsExpandedDuration = isExpand
    }
    
    func refreshViews() {
        if !settingData.bIsNotJustNow {
            
                lblTimeBothText.text = "Time Bottle"
                lblDuration1.text = "Duration Bottle"
                lblDuration2.text = "Duration Bottle"
                lblDurationInfo1.text = ""
                lblDurationInfo2.text = ""
            
        }
        else {
            
                lblTimeBothText.text = "Time Bottle"
                lblDurationJust.text = "Duration Bottle"
                lblDurationJustExpand.text = "Duration Bottle"
           
        }
        
        tableView.reloadData()
    }
    
    func dismiss() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func checkItemChanged() {
        
        // check all any item changed
        bItemChanged = false
        
        repeat {
            let formatter : NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            // check left time, durations
            //if settingData.optAction != BothMoreSettingData.BreastActions.ActRight {
                
                let timeLeftInit = formatter.stringFromDate(init_settingData.timeLeft!)
                let timeLeftSetting = formatter.stringFromDate(settingData.timeLeft!)
                if !timeLeftSetting.isEqual(timeLeftInit) {
                    bItemChanged = true
                    break
                }
            
                if timer.valid || startTime > 0
                {
                    bItemChanged = true
                    break
                }
        
                if init_settingData.nLeftDurationHours != settingData.nLeftDurationHours {
                    bItemChanged = true
                    break
                }
                
                if init_settingData.nLeftDurationMinutes != settingData.nLeftDurationMinutes {
                    bItemChanged = true
                    break
                }
           // }
            
            
            
        /*    if init_settingData.bIsNotJustNow != settingData.bIsNotJustNow {
                bItemChanged = true
                break
            }
        */
            
            if (logEvent.value > 0)
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
            
            if init_settingData.strNoteText != settingData.strNoteText {
                bItemChanged = true
                break
            }
            
            if init_settingData.bottleImage != settingData.bottleImage {
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
    
    func getIntValue(eventObj:Int?, limitMin:Int, limitMax:Int, valueMin:Int, valueMax:Int) ->Int {
        var retValue:Int! = valueMin
        
        if eventObj != nil {
            retValue = eventObj
        }
        
        if retValue < limitMin {
            retValue = valueMin
        }
        
        if retValue > limitMax {
            retValue = valueMax
        }
        
        return retValue
    }
    
    var logEvent = LogEvent() {
        didSet {
            
            // convert LogEvent to PoopMoreSettingData
            
            settingData.bIsNotJustNow = logEvent.bIsJustNow
            settingData.bDisplayDescription = logEvent.displayDesc
            
           
            
           
            settingData.timeLeft = logEvent.timeLeft
            if settingData.timeLeft == nil
            {
                settingData.timeLeft = NSDate.init()
            }
                
                
            
            
           
                settingData.nLeftDurationHours = getIntValue(logEvent.leftHours, limitMin: 0, limitMax: 59, valueMin: 0, valueMax: 59)
                settingData.nLeftDurationMinutes = getIntValue(logEvent.leftMins, limitMin: 0, limitMax: 59, valueMin: 0, valueMax: 59)
                
                
            
            settingData.bIsSelectedStar = logEvent.starMark
            settingData.bIsSelectedExclamation = logEvent.exclamationMark
            
            if let note = logEvent.note {
                settingData.strNoteText = note
            }
            
            // TODO image
            settingData.bottleImage = nil   // ???
            
            // save initialize setting data
            init_settingData.bIsNotJustNow = settingData.bIsNotJustNow
            init_settingData.timeLeft = NSDate.init(timeInterval: 0, sinceDate: settingData.timeLeft!)
            init_settingData.bDisplayDescription = settingData.bDisplayDescription
            init_settingData.bIsSelectedStar = settingData.bIsSelectedStar
            init_settingData.bIsSelectedExclamation = settingData.bIsSelectedExclamation
            init_settingData.nLeftDurationHours = settingData.nLeftDurationHours
            init_settingData.nLeftDurationMinutes = settingData.nLeftDurationMinutes
            init_settingData.strNoteText = settingData.strNoteText
            init_settingData.bottleImage = settingData.bottleImage
        }
    }
    
    func takePhoto(){
        getPicture(.Camera)
    }
    
    func getExisting(){
        getPicture(.PhotoLibrary)
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
        breastImageView.image = original
        
        //making it clickable
        self.breastImageView.userInteractionEnabled = true
        self.breastImageView.backgroundColor = UIColor.redColor()
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(BottleMoreVC.imageTapped(_:)))
        self.breastImageView.addGestureRecognizer(tapImage)
        
        if breastImageView.image != nil {
            
            settingData.bottleImage = breastImageView.image
            checkItemChanged()
            
            if imageViewHeightConstraint.constant == 0 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.imageViewHeightConstraint.constant = 120
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                    
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func initBottleUIs() {
        
        
        // change Navigation title
        
    
        
       self.title = "Bottle More"
       
        
    //   lblQuantityPump.text = String(format: "Quantity %@", logEvent.subtitle().capitalizedString)
        
        refreshViews()
    }
    
    //=============================================================
    
    //===============================================
    //      UITableView Deelgate
    //===============================================
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let currCell:kBottleContentCell = kBottleContentCell(rawValue: indexPath.row)!
        
        switch (currCell)
        {
        case .NotNustNow:     // id_NotJustNow
            return 45
        
        case .TimeBoth:     // id_TimeBoth
            if settingData.bIsNotJustNow {
                return 45
            }
            return 0
            
        case .DateTimePicker:     // id_DateTimePicker
            if bIsVisibleTimePicker == false || !settingData.bIsNotJustNow {
                return 0
            }
            return 160
            
        case .QualityBottleSlider:
            return 90
            
        case .LeftRight:     // id_LeftRight
           
                return 20
            
        case .DurationNoExpand:     // id_DurationNoExpand
            if settingData.bIsNotJustNow {
                return 0
            }
            else if bIsExpandedDuration {
                return 0
            }
            return 133
            
        case .DurationExpand:     // id_DurationExpand
            if settingData.bIsNotJustNow {
                return 0
            }
            else if bIsExpandedDuration {
                return 270
            }
            return 0
            
        case .DurationNoExpandNotJustNow:     // id_DurationNoExpandNotJustNow
            if settingData.bIsNotJustNow {
                if bIsExpandedDuration {
                    return 0
                }
                return 45
            }
            return 0
            
        case .DurationExpandNotJustNow:     // id_DurationExpandNotJustNow
            if settingData.bIsNotJustNow {
                if bIsExpandedDuration {
                    return 190
                }
            }
            return 0
            
        case .Bell:    // id_Bell
            return 96
            
        case .StarOrExclamation:    // id_StarOrExclamation
            return 96
            
        case .Camera:    // id_Camera
            // add Marko
            if settingData.bottleImage != nil {
                return 170
            }
            return 45
            
        case .SeperateEnd:
            return 70
            
        default:
            return 20
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
            let deltaEdge = UIEdgeInsets(top:0,left:15,bottom:0,right:0)
            
            let currCell:kBottleContentCell = kBottleContentCell(rawValue: indexPath.row)!
            
            switch (currCell) {
              
            case .QualityBottleSlider:
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
            case .NotNustNow:
                cell.separatorInset = deltaEdge
                return
                
            case .TimeBoth:
                cell.separatorInset = deltaEdge
                return
                
                
            case .DateTimePicker:
                cell.separatorInset = deltaEdge
                return
            default:
                return
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (self.txtQty.isFirstResponder())
        {
            self.txtQty.resignFirstResponder()
            return
        }

        
        let currCell:kBottleContentCell = kBottleContentCell(rawValue: indexPath.row)!
        
        if currCell == .DurationNoExpand {
            
            
            if startTime > 0
            {
                let alert = UIAlertController(title: "", message: "Please reset the stopwatch to 00:00 if you wish enter Duration manually", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
                
            }

        }
        
        
        let t = datePicker.date
        
        var hours = 0
        var minutes = 0
        
        if !settingData.bIsNotJustNow {
            hours = pickerHours.selectedRowInComponent(0)
            minutes = pickerMinutes.selectedRowInComponent(0)
        }
        else {
            hours = pickerHoursJust.selectedRowInComponent(0)
            minutes = pickerMinutesJust.selectedRowInComponent(0)
        }
        
        
        if currCell == .TimeBoth {
            if bIsVisibleTimePicker{
                
                    settingData.timeLeft = t
                               
            }
            
            refreshDatePicker(!bIsVisibleTimePicker)
            refreshViews()
        }
        
        if currCell == .DurationNoExpand {
            
            
            if startTime > 0
            {
                let alert = UIAlertController(title: "", message: "Please reset the Duration Picker to Not Set if you wish use the stopwatch", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                return

            }
            
            refreshViewPicker(true)
            refreshViews()
        }
        
        if currCell == .DurationExpand {
           
                settingData.nLeftDurationHours = hours
                settingData.nLeftDurationMinutes = minutes
        
            refreshViewPicker(false)
            refreshViews()
        }
        
        // Marko
        if currCell == .DurationNoExpandNotJustNow {
            refreshViewPicker(true)
            refreshViews()
        }
        
        if currCell == .DurationExpandNotJustNow {
            
                settingData.nLeftDurationHours = hours
                settingData.nLeftDurationMinutes = minutes
            
            refreshViewPicker(false)
            refreshViews()
        }
        
        checkItemChanged()
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
}
