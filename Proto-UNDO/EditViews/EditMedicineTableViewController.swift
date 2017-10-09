//
//  EditMedicineTableViewController.swift
//  NoteMore
//
//  Created by Curly Brackets on 9/26/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//
enum kEditMedicineContentCell : Int {
    case SplitterFirst = 0
    case TimeLeft           //3
    case DateTimePicker     //4
    case Quantity
    case QuantityPicker
    case Splitter2
    case DurationCell
    case Splitter4
    case ParentCell
    case Splitter5
    case StarOrExclamation  //10
    case Splitter3          //11
    case Camera             //12
    case SplitterLast          //13
    case DeleteCell         //14
    
}
import UIKit

class EditMedicineTableViewController: UITableViewController,  UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var labelParent: UILabel!
    
    var durationHour: NSInteger! = 0
    var durationMin: NSInteger! = 0
    
    var logEvent : LogEvent!
    var mSelectedIndex: NSInteger! = 0
    var bIsVisibleTimePicker:Bool = false
    var isVisibleQuantityPicker = false
    var bIsExpandedDuration:Bool = false
    
    
    //===============================================
    
    @IBOutlet weak var durationHourPickerView: UIPickerView!
    @IBOutlet weak var durationMinPickerView: UIPickerView!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDurationTitle: UILabel!

    
    //===============================================
    
    @IBOutlet weak var lblTimeBothText: UILabel!
    
    @IBOutlet weak var lblTimeResult: UILabel!
    
    //============================================
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //===============================================
    @IBOutlet weak var lblQuantityText: UILabel!
    
    @IBOutlet weak var lblQuantityResult: UILabel!
    
    @IBOutlet weak var pickerQuanityResult: UIPickerView!
    // ============================================
    @IBOutlet weak var memoTextInput: UITextField!
    
    // ============================================
    
    @IBOutlet weak var btnDelete: UIButton!
    
    // ============================================
    
    @IBOutlet weak var btnParent: UIButton!
    
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
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(EditMedicineTableViewController.imageTapped(_:)))
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
        
        
        // Add activity indicator
        activityIndicator.center = self.tableView.center
        activityIndicator.color = UIColor.darkGrayColor()
        tableView.addSubview(activityIndicator)
        
        DataSource.sharedDataSouce.updateEventWithIndex(self.mSelectedIndex, logEvent: logEvent)
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        self.activityIndicator.startAnimating()
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
        lblTimeResult.text = logEvent.dateTimeStringFromDate(datePicker.date);
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

    @IBAction func OnParentTapped(sender: AnyObject) {
        logEvent.parentMark = !logEvent.parentMark
        SetParent(logEvent.parentMark)
    }
    
    func SetParent(isSel:Bool)
    {
        let nonSelectedColor = UIColor(red:0.52, green:0.55, blue:0.60, alpha:1.0)
        let selectedColor = UIColor(red:1.0, green:176.0/255.0, blue:64.0/255.0, alpha:1.0)
        
        
        labelParent.textColor =  isSel ? selectedColor : nonSelectedColor
        
        btnParent.tintColor = isSel ? selectedColor : nonSelectedColor
    }
    
    func refreshDatePicker(isExpand:Bool){
        var t = initTime
        t = NSDate(timeIntervalSinceReferenceDate: logEvent.time)
        
        lblTimeResult.text = logEvent.dateTimeStringFromDate(t!);
        
        datePicker.setDate(t!, animated: true)
        bIsVisibleTimePicker = isExpand
    }
    
    func dataChanged()
    {
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
       self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func refreshQuantityPicker(isExpand: Bool) {
        var quantity : Int? = 0
        if self.lblQuantityResult.text != "Not Set"
        {
          quantity  = Int(self.lblQuantityResult.text!)
        }
        
        self.pickerQuanityResult.selectRow(quantity!, inComponent: 0, animated: false)

        isVisibleQuantityPicker = isExpand
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if logEvent.leftHours != nil
        {
            durationHour = logEvent.leftHours
        }
        
        if logEvent.leftMins != nil
        {
            durationMin  = logEvent.leftMins
        }
        
        
        
        durationHourPickerView.selectRow(durationHour, inComponent: 0, animated:true)
        durationMinPickerView.selectRow(durationMin, inComponent: 0, animated:true)
        
        SetDuration()

        
        let nonSelectedColor = UIColor(red:0.52, green:0.55, blue:0.60, alpha:1.0)
        btnParent.tintColor =  nonSelectedColor
        labelParent.textColor =  nonSelectedColor
   
        
        labelParent.font = UIFont.systemFontOfSize(14)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(EditMedicineTableViewController.dataChanged), name: kLogObjectUpdatedNotification, object: nil)
        
        btnDelete.clipsToBounds = true
        btnDelete.layer.cornerRadius = 13
        
        initTime = NSDate(timeIntervalSinceReferenceDate: logEvent.time)
        
        datePicker.addTarget(self, action: #selector(EditMedicineTableViewController.datePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)

        memoTextInput.attributedPlaceholder = NSAttributedString(string: memoTextInput.text!, attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        
        memoTextInput.text = "";
        
        let event: LogEvent! = DataSource.sharedDataSouce.EventAtIndex(mSelectedIndex);
        lblTimeBothText.text = "Time \(event.subtitle())"
        lblDurationTitle.text = "Duration \(event.subtitle())"
        
          if ( event.quantity == 0 )
        {
            lblQuantityResult.text = "Not Set"
            lblQuantityResult.textColor = UIColor.lightGrayColor()
        }
        else
        {
            lblQuantityResult.text = "\(event.quantity)"
            lblQuantityResult.textColor = UIColor.blackColor()
        }
        
        
        self.title = "\(event.subtitle()) Edit"
        
        // by Marko
        // Update UIs according the settings Data
        SetStar(logEvent.starMark)
        SetExclamation(logEvent.exclamationMark)
        SetParent(logEvent.parentMark)
        
        memoTextInput.text = logEvent.note
        
        // Load Image From Parse
        logEvent.getImage { (image : UIImage?, error : NSError?) -> Void in
            
            if image == nil || error != nil {
                
            }
            else {
                
                self.memoImageView.image = image!
                
                self.memoImageView.userInteractionEnabled = true
                
                let tapImage = UITapGestureRecognizer(target: self, action: #selector(EditMedicineTableViewController.imageTapped(_:)))
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
        let type:kEditMedicineContentCell = kEditMedicineContentCell(rawValue: indexPath.row)!
        
        switch(type)
        {
            
        case .TimeLeft:
            return 45
        case .DateTimePicker:
            if bIsVisibleTimePicker == false {
                return 0
            }
            return 160
        case .Quantity:
            return 45
        case .QuantityPicker:
            if isVisibleQuantityPicker == false {
                return 0
            }
            return 180
        case .DurationCell:
            if !bIsExpandedDuration
            {
                return 45
            }
            return 205
        case .ParentCell:
            return 96
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
        let t = datePicker.date
        //let hours = pickerHours.selectedRowInComponent(0)
        //let minutes = pickerMinutes.selectedRowInComponent(0)
        let type:kEditMedicineContentCell = kEditMedicineContentCell(rawValue: indexPath.row)!
        
        switch (type){
        case .TimeLeft:
            if bIsVisibleTimePicker{
                logEvent.time = t.timeIntervalSinceReferenceDate
            }
            refreshDatePicker(!bIsVisibleTimePicker)
            refreshViews()
//        case .Interval:
//            refreshViews()
            
        case .DurationCell:
            bIsExpandedDuration = !bIsExpandedDuration
            refreshViews()
            
        case .Quantity:
            
            if isVisibleQuantityPicker {
//                logEvent.quantity = 
            }
            refreshQuantityPicker(!isVisibleQuantityPicker)
            refreshViews()

        default:
            refreshViews()
        }
    }
    
    // The number of columns of data
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    
    
    // MARK: - UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        event.quantity = row
        if pickerView == self.pickerQuanityResult {
            logEvent.quantity = row
            lblQuantityResult.text = "\(row)"
            refreshQuantityPicker(!isVisibleQuantityPicker)
            refreshViews()
            
            if ( row == 0 )
            {
                lblQuantityResult.text = "Not Set"
                lblQuantityResult.textColor = UIColor.lightGrayColor()
                
            }
            else
            {
                lblQuantityResult.text = "\(row)"
                lblQuantityResult.textColor = UIColor.blackColor()
            }
            
        }
        else
        {
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
    }
    
    
    
   
    
   
    
    func SetDuration()
    {
     
        
        logEvent.leftHours = durationHour
        logEvent.leftMins = durationMin
        
        
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
