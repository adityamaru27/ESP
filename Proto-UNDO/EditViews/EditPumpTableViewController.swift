//
//  EditPumpTableViewController.swift
//  NoteMore
//
//  Created by Curly Brackets on 9/26/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//
enum kEditPumpContentCell : Int {
    case SplitterFirst = 0
    case TimeLeft           //3
    case DateTimePicker     //4
    case QuantityCell
    case Splitter1
    case DurationCell
    case Splitter5
    case StarOrExclamation  //10
    case Splitter3          //11
    case Camera             //12
    case SplitterLast          //13
    case DeleteCell         //14
    
}
import UIKit

class EditPumpTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate  {
    
    var logEvent : LogEvent!
    var mSelectedIndex: NSInteger! = 0
    var durationHour: NSInteger! = 0
    var durationMin: NSInteger! = 0
    var bIsVisibleTimePicker:Bool = false
    var bIsExpandedQuantity:Bool = false
    var bIsExpandedDuration:Bool = false
    
    //===============================================
    
    @IBOutlet weak var lblTimeBothText: UILabel!
    
    @IBOutlet weak var lblTimeResult: UILabel!
    
    //============================================
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // ============================================
    @IBOutlet weak var memoTextInput: UITextField!
    
    // ============================================
    
    @IBOutlet weak var btnDelete: UIButton!
    
    // ============================================
    
       // ============================================

    @IBOutlet weak var durationHourPickerView: UIPickerView!
    @IBOutlet weak var durationMinPickerView: UIPickerView!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDurationTitle: UILabel!
    
    // ============================================
 
    
    
    //===============================================
    
    
    @IBOutlet weak private var descriptionLabel: UILabel!
    
    @IBOutlet weak private var valueLabel: UILabel!
    
    @IBOutlet weak var txtQty: UITextField!
    
    //===============================================
    
    
    
    
    
    
    // Activity Indicator
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
 
    @IBOutlet weak var memoImageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    // by Marko
    // MARK: - View life cycle
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden=false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.hidden=false
    }
    
    // by Marko
    // MARK: - IBAction slot
    
    @IBAction func onTapDelete(sender: AnyObject) {
        activityIndicator.center = self.tableView.center
        activityIndicator.color = UIColor.darkGrayColor()
        tableView.addSubview(activityIndicator)
        
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this log?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (ACTION :UIAlertAction!) in
            
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler:{ (ACTION :UIAlertAction!)in
            DataSource.sharedDataSouce.deleteEventWithIndex(self.mSelectedIndex)
            self.activityIndicator.startAnimating()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
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
        
        memoTextInput.resignFirstResponder()
        
        
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
        memoImageView.image = original
        
        //making it clickable
        self.memoImageView.userInteractionEnabled = true
        self.memoImageView.backgroundColor = UIColor.redColor()
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(EditPumpTableViewController.imageTapped(_:)))
        self.memoImageView.addGestureRecognizer(tapImage)
        
        if memoImageView.image != nil {
            
            logEvent.image =  memoImageView.image
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
    
    @IBAction func onTapCancel(sender: AnyObject) {
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onTapSave(sender: AnyObject) {
        
        // save function
        // Convert SettingsData to LogEvent
//        logEvent.starMark = settingData.bIsSelectedStar
//        logEvent.exclamationMark = settingData.bIsSelectedExclamation
//        logEvent.babyMark = settingData.bBabysitter
//        logEvent.doctorMark = settingData.bDoctor
//        logEvent.bIsJustNow = settingData.bIsNotJustNow
//        logEvent.noteTime = settingData.time
//        logEvent.image = settingData.memoImage

        // Assign Text
        if let text = memoTextInput.text {
            logEvent.note = text
        }
        else {
            logEvent.note = ""
        }
        
        if ( txtQty.text?.characters.count > 0)
        {
            logEvent.value = Float(txtQty.text!)!
        }
        
        // Add activity indicator
        activityIndicator.center = self.tableView.center
        activityIndicator.color = UIColor.darkGrayColor()
        tableView.addSubview(activityIndicator)
        
        DataSource.sharedDataSouce.updateEventWithIndex(self.mSelectedIndex, logEvent: logEvent)
     
       
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        self.activityIndicator.startAnimating()
        
        
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
    
//    var logEvent = LogEvent() {
//        didSet {
//            
//            // convert LogEvent to NoteMoreSettingData
//            settingData.bIsSelectedStar = logEvent.starMark
//            settingData.bIsSelectedExclamation = logEvent.exclamationMark
//            settingData.bBabysitter = logEvent.babyMark
//            settingData.bDoctor = logEvent.doctorMark
//            
//            settingData.bIsNotJustNow = logEvent.bIsJustNow
//            settingData.time = logEvent.noteTime
//            if settingData.time == nil {
//                settingData.time = NSDate()
//            }
//            
//            if let note = logEvent.note {
//                settingData.strNoteText = note
//            }
//        }
//    }
    
    // MARK: - Previous Code
    func datePickerValueChanged(sender: UIDatePicker)
    {
        logEvent.time = datePicker.date.timeIntervalSinceReferenceDate;
       // lblTimeResult.text = dateFormatter.stringFromDate(datePicker.date);
        lblTimeResult.text =  logEvent.dateTimeStringFromDate(datePicker.date)
        
    }
    
//    func getDateFormat(selectedTime:NSDate) -> String
//    {
//        let dateFormatter = NSDateFormatter()
//        var text : String = ""
//        if NSCalendar.currentCalendar().isDateInToday(selectedTime) {
//            dateFormatter.dateFormat = "h:mm a"
//            text = "Today " + dateFormatter.stringFromDate(selectedTime)
//        }else if NSCalendar.currentCalendar().isDateInTomorrow(selectedTime) {
//            dateFormatter.dateFormat = "h:mm a"
//            text = "Tomorrow " + dateFormatter.stringFromDate(selectedTime)
//        }else if NSCalendar.currentCalendar().isDateInYesterday(selectedTime) {
//            dateFormatter.dateFormat = "h:mm a"
//            text = "Yesterday " + dateFormatter.stringFromDate(selectedTime)
//        }else {
//            dateFormatter.dateFormat = "MM-dd h:mm a"
//            text = dateFormatter.stringFromDate(selectedTime)
//        }
//        return text
//    }
    
    lazy var dateFormatter : NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter
        }()

    
    var oldState = 0
    var initTime:NSDate?
    
    @IBOutlet weak var btnStar: UIButton!
    
    @IBOutlet weak var btnExclamation: UIButton!
    
    @IBOutlet weak var imgStar: UIImageView!
    
    @IBOutlet weak var imgExclamation: UIImageView!
    
    @IBAction func OnStarTapped(sender: UIButton) {
        SetStar(!logEvent.starMark)
    }
    
    @IBAction func OnExclamationTapped(sender: UIButton) {
        SetExclamation(!logEvent.exclamationMark)
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
        logEvent.starMark = isSel
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
        logEvent.exclamationMark = isSel
    }
    
    func refreshDatePicker(isExpand:Bool){
        var t = initTime
        t = NSDate(timeIntervalSinceReferenceDate: logEvent.time)
        
      //  lblTimeResult.text = dateFormatter.stringFromDate(t!);
        
         lblTimeResult.text =  logEvent.dateTimeStringFromDate(t!)
        
        datePicker.setDate(t!, animated: true)
        bIsVisibleTimePicker = isExpand
    }
    
    
    
    func doneClicked(sender: AnyObject) {
        self.view.endEditing(true)
        
        
        
    }
    
    func cancelClicked(sender: AnyObject) {
        self.view.endEditing(true)
    }

    
    
    func dataChanged()
    {
        
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        valueLabel.font = UIFont(name: "SFUIText-Regular", size: 17.0)
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
        
       
        
        
        
        //  let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        //view.addGestureRecognizer(tap)
        
        
        if ((NSUserDefaults.standardUserDefaults().objectForKey("Measurements")?.isEqualToString("oz")) == true) {
            valueLabel.text = "oz"
        }
        else
        {
            valueLabel.text = "mL"
        }
        
        memoTextInput.textColor = UIColor.blackColor()

        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(EditPumpTableViewController.dataChanged), name: kLogObjectUpdatedNotification, object: nil)
        
        btnDelete.clipsToBounds = true
        btnDelete.layer.cornerRadius = 13
        
        initTime = NSDate(timeIntervalSinceReferenceDate: logEvent.time)
        
        datePicker.addTarget(self, action: #selector(EditPumpTableViewController.datePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)

        memoTextInput.attributedPlaceholder = NSAttributedString(string: memoTextInput.text!, attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        
        memoTextInput.text = "";
        
        let event: LogEvent! = DataSource.sharedDataSouce.EventAtIndex(mSelectedIndex);
        lblTimeBothText.text = "Time \(event.subtitle())"
        
        if Int(logEvent.value) == 0
        {
            //lblQuantity.textColor  = UIColor.lightGrayColor()
        }
        
        var unit = "oz"
        
        if ((NSUserDefaults.standardUserDefaults().objectForKey("Measurements")?.isEqualToString("oz")) == false) {
            unit = "mL"
        }
        
        
        txtQty.text = "\(Int(round(logEvent.value)))"
        

        //lblQuantity.text = "\(Int(logEvent.value)) " + unit
        
        
        
       // quantitySlider.value = logEvent.value
        
       // lblQuantityTitle.text = "Quantity \(event.subtitle())"
        lblDurationTitle.text = "Duration \(event.subtitle())"
        
        self.title = "\(event.subtitle()) Edit"
        
      //  lblQuantityHeightConstraint.constant = 0.5
        
        if logEvent.action.isEqualToString("left") {
            
            if event.leftHours != nil
            {
                durationHour = event.leftHours
            }
            
            if event.leftMins != nil
            {
               durationMin  = event.leftMins
            }
            
        }
        else
        {
            if event.rightHours != nil
            {
              durationHour = event.rightHours
            }
            
            if event.rightMins != nil
            {
              durationMin  = event.rightMins
            }
        }

       
        durationHourPickerView.selectRow(durationHour, inComponent: 0, animated:true)
        durationMinPickerView.selectRow(durationMin, inComponent: 0, animated:true)
        SetDuration()
        
        // by Marko
        // Update UIs according the settings Data
        SetStar(logEvent.starMark)
        SetExclamation(logEvent.exclamationMark)
        
        memoTextInput.text = logEvent.note
        
        // Load Image From Parse
        logEvent.getImage { (image : UIImage?, error : NSError?) -> Void in
            
            if image == nil || error != nil {
                
            }
            else {
                
                self.memoImageView.image = image!
                
                self.memoImageView.userInteractionEnabled = true
                
                let tapImage = UITapGestureRecognizer(target: self, action: #selector(EditPumpTableViewController.imageTapped(_:)))
                self.memoImageView.addGestureRecognizer(tapImage)
                
                self.imageViewHeightConstraint.constant = 120
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                
                self.tableView.reloadData()
            }
        }
        
        refreshDatePicker(false)
        refreshViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //       return UITableViewAutomaticDimension
        let type:kEditPumpContentCell = kEditPumpContentCell(rawValue: indexPath.row)!
        
        switch(type)
        {
            
        case .TimeLeft:
            return 45
        case .DateTimePicker:
            if bIsVisibleTimePicker == false {
                return 0
            }
            return 160
        case .QuantityCell:
            return 70
        case .DurationCell:
            if !bIsExpandedDuration
            {
                return 45
            }
            return 205
        case .StarOrExclamation:
            return 96
        case .Camera:
            
            if logEvent.image != nil {
                return 170
            }
            return 45
        case .DeleteCell:
            return 57;
        
        case .SplitterFirst:
            return 35
        case .SplitterLast:
            return 35
            
        default:
            return 20
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
//        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
//            let type:kContentCell = kContentCell(rawValue: indexPath.row)!
//            let deltaEdge = UIEdgeInsets(top:0,left:0,bottom:0,right:0)
//            switch type {
//            case .TimeLeft,.DateTimePicker:
//                cell.separatorInset = deltaEdge
//            default:
//                return
//            }
//        }
    }
    
    func refreshViews() {
        tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (self.txtQty.isFirstResponder())
        {
            self.txtQty.resignFirstResponder()
            return
        }
        
        let t = datePicker.date
        //let hours = pickerHours.selectedRowInComponent(0)
        //let minutes = pickerMinutes.selectedRowInComponent(0)
        let type:kEditPumpContentCell = kEditPumpContentCell(rawValue: indexPath.row)!
        
        switch (type){
        case .TimeLeft:
            if bIsVisibleTimePicker{
                logEvent.time = t.timeIntervalSinceReferenceDate
            }
            refreshDatePicker(!bIsVisibleTimePicker)
            refreshViews()
        case .QuantityCell:
            bIsExpandedQuantity = !bIsExpandedQuantity
            refreshViews()
        case .DurationCell:
            bIsExpandedDuration = !bIsExpandedDuration
            refreshViews()
//        case .Interval:
//            refreshViews()
        default:
            refreshViews()
        }
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if ( textField.tag == 1001 )
        {
            if ( textField.text?.characters.count > 0)
            {
                logEvent.value = Float(textField.text!)!
            }
        }
    }
    
    
    // MARK: - UISlider
    
    @IBAction func quantityChanged(sender: AnyObject) {
      //  lblQuantity.text = "\(Int(quantitySlider.value)) oz"
      //  logEvent.value = quantitySlider.value
      //  lblQuantity.textColor = UIColor.blackColor()
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == durationHourPickerView
        {
            return 24
        }
        
        return 60
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == durationHourPickerView
        {
            durationHour = row
        }
        else
        {
            durationMin = row
        }
        
        SetDuration()
    }
    
    func SetDuration()
    {
      /*  if durationHour == 0
        {
            lblDuration.text = durationMin > 1 ? "\(durationMin) mins" : "\(durationMin) min"
        }
        else
        {
            lblDuration.text = "\(durationHour) hr   \(durationMin) min"
        }
        */
        
        
        if logEvent.action.isEqualToString("left") {
       
            logEvent.leftHours = durationHour
            logEvent.leftMins = durationMin
        }
        else
        {
            logEvent.rightHours = durationHour
            logEvent.rightMins = durationMin
        }
    
        
        if durationHour > 0 || durationMin > 0
        {
        
        lblDuration.text = logEvent.getPickerFormat(durationHour, minutes: durationMin)
        
          lblDuration.textColor = UIColor.blackColor()
        }
        else
        {
             lblDuration.textColor = UIColor.lightGrayColor()
            lblDuration.text = "Not Set"
        }

    }

}
