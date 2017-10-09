//
//  MedicineMoreViewController.swift
//  Proto-UNDO
//
//  Created by Santu C on 15/11/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

enum kMedicineContentCell : Int {
    case SplitterFirst = 0
    case TimeLeft           //3
    case DateTimePicker     //4
    case Quantity
    case QuantityPicker
    case Splitter2
    case ParentCell
    case Splitter5
    case StarOrExclamation  //10
    case Splitter3          //11
    case Camera             //12
    case SplitterLast          //13
    case DeleteCell         //14
    
}
import UIKit


class MedicineMoreViewController: UITableViewController,  UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
    let NVItemSaveColor:UIColor = UIColor(red:255.0/255.0, green:59.0/255.0, blue:48.0/255.0, alpha:1.0) // #FF3B30
    let NVItemDefaultColor:UIColor = UIColor(red:0.0/255.0, green:122.0/255.0, blue:255.0/255.0, alpha:1.0) // #007AFF
  
    
    var settingData:MedicineSettingData = MedicineSettingData()
    var init_settingData:MedicineSettingData = MedicineSettingData()
    
     var bItemChanged:Bool = false
    
   // var logEvent : LogEvent!
    var mSelectedIndex: NSInteger! = 0
    var bIsVisibleTimePicker:Bool = false
    var isVisibleQuantityPicker = false
    var bIsExpandedDuration:Bool = false
    
    
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
 
    
    @IBOutlet weak var labelParent: UILabel!
    
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
    
    
    // ============================================
    
    @IBOutlet weak var btnParent: UIButton!
    
    
    
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
    
    
    
    
    func checkItemChanged() {
        
        // check all any item changed
        bItemChanged = false
        
        repeat {
            let formatter : NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            // check left time, durations
            //if settingData.optAction != BothMoreSettingData.BreastActions.ActRight {
            
            
            if init_settingData.time != settingData.time {
                bItemChanged = true
                break
            }

            
            if init_settingData.Quantity != settingData.Quantity {
                bItemChanged = true
                break
            }

            
            
            if init_settingData.bIsSelectedParent != settingData.bIsSelectedParent {
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
          //  btnSave.tintColor = NVItemDefaultColor
          //  btnSave.enabled = false
        }
    }
    
    
    
    
    var logEvent = LogEvent() {
        didSet {
            
            // convert LogEvent to PoopMoreSettingData
            
            
            settingData.time = logEvent.time
            if settingData.time == 0
            {
                settingData.time = NSDate().timeIntervalSince1970
            }
            
            settingData.Quantity = logEvent.quantity
            if settingData.time == 0
            {
                settingData.Quantity = 1
            }
            
            settingData.bIsSelectedParent = logEvent.parentMark
            settingData.bIsSelectedStar = logEvent.starMark
            settingData.bIsSelectedExclamation = logEvent.exclamationMark
            
            if let note = logEvent.note {
                settingData.strNoteText = note
            }
            
            // TODO image
            settingData.bottleImage = nil   // ???
            
            // save initialize setting data
         
            init_settingData.time = settingData.time
            init_settingData.Quantity = settingData.Quantity
            init_settingData.bIsSelectedParent = settingData.bIsSelectedParent
            init_settingData.bIsSelectedStar = settingData.bIsSelectedStar
            init_settingData.bIsSelectedExclamation = settingData.bIsSelectedExclamation
           
            init_settingData.strNoteText = settingData.strNoteText
            init_settingData.bottleImage = settingData.bottleImage
        }
    }
    
    
    
    // by Marko
    // MARK: - IBAction slot
    /*
    @IBAction func onTapDelete(sender: AnyObject) {
        activityIndicator.center = self.tableView.center
        activityIndicator.color = UIColor.darkGrayColor()
        tableView.addSubview(activityIndicator)
        
        let alert = UIAlertController(title: "Confirm", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (ACTION :UIAlertAction!) in
            
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
            DataSource.sharedDataSouce.deleteEventWithIndex(self.mSelectedIndex)
            self.activityIndicator.startAnimating()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    */
    
    
    
    
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
        if memoImageView.image != nil {
            
            settingData.bottleImage =  memoImageView.image
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
    
    func dismiss() {
        navigationController?.popViewControllerAnimated(true)
    }

    
    @IBAction func onTapCancel(sender: AnyObject) {
        
        memoTextInput.resignFirstResponder()
        if bItemChanged {
            let alertController = UIAlertController(title: nil, message: "Are you sure to \"Cancel\"?\nThe event will be deleted", preferredStyle: .ActionSheet)
            
            let deleteAction = UIAlertAction(title: "Yes, cancel and delete", style: .Destructive){ (action) in
                
        
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
   /*     if let text = memoTextInput.text {
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
   */
        
       
        // save functions
        // Convert SettingData to LogEvent
        
       
        logEvent.time = settingData.time
        logEvent.quantity = settingData.Quantity
        logEvent.parentMark = settingData.bIsSelectedParent
        
        logEvent.starMark = settingData.bIsSelectedStar
        logEvent.exclamationMark = settingData.bIsSelectedExclamation
        logEvent.image = settingData.bottleImage
        // Assign Text
        if let text = memoTextInput.text {
            settingData.strNoteText = text
        }
        else {
            settingData.strNoteText = ""
        }
        logEvent.note = settingData.strNoteText
        
        
        
        if ( settingData.bIsNotJustNow)
        {
            logEvent.time = datePicker.date.timeIntervalSinceReferenceDate
        }
        
        
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
        settingData.time = datePicker.date.timeIntervalSinceReferenceDate
        lblTimeResult.text = logEvent.dateTimeStringFromDate(datePicker.date)
        
         checkItemChanged()  
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
        SetStar(!settingData.bIsSelectedStar)
        checkItemChanged()
    }
    
    @IBAction func OnExclamationTapped(sender: UIButton) {
        SetExclamation(!settingData.bIsSelectedExclamation)
         checkItemChanged()
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
       // logEvent.starMark = isSel
        
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
        //logEvent.exclamationMark = isSel
        settingData.bIsSelectedExclamation = isSel
        
    }
    
    @IBAction func OnParentTapped(sender: AnyObject) {
        
        settingData.bIsSelectedParent  =  !settingData.bIsSelectedParent
        SetParent(settingData.bIsSelectedParent)
        
         checkItemChanged()
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
        t = NSDate(timeIntervalSinceReferenceDate: settingData.time)
        
       // lblTimeResult.text = dateFormatter.stringFromDate(t!);
        
        lblTimeResult.text = logEvent.dateTimeStringFromDate(t!)
        
        datePicker.setDate(t!, animated: true)
        bIsVisibleTimePicker = isExpand
    }
    
    func dataChanged()
    {
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func refreshQuantityPicker(isExpand: Bool) {
        let quantity : Int? = Int(self.lblQuantityResult.text!)
        self.pickerQuanityResult.selectRow(quantity!, inComponent: 0, animated: false)
        
        isVisibleQuantityPicker = isExpand
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(MedicineMoreViewController.dataChanged), name: kLogObjectUpdatedNotification, object: nil)
        
      
        lblQuantityText.text = "Quantity \(logEvent.item!.actions[0].name.capitalizedString)"
        
        let nonSelectedColor = UIColor(red:0.52, green:0.55, blue:0.60, alpha:1.0)
        btnParent.tintColor =  nonSelectedColor
        labelParent.textColor =  nonSelectedColor
        
        
        labelParent.font = UIFont.systemFontOfSize(14)
        
        initTime = NSDate(timeIntervalSinceReferenceDate: settingData.time)
        
        datePicker.addTarget(self, action: #selector(MedicineMoreViewController.datePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        memoTextInput.attributedPlaceholder = NSAttributedString(string: memoTextInput.text!, attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        
        memoTextInput.text = "";
        
        let event: LogEvent! = DataSource.sharedDataSouce.EventAtIndex(mSelectedIndex);
        lblTimeBothText.text = "Time \(logEvent.item!.actions[0].name.capitalizedString)"
        lblQuantityResult.text = event.quantity.description
        
        
       self.title = "\(logEvent.item!.actions[0].name.capitalizedString) More"
        
        
    /*    // by Marko
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
                
                self.imageViewHeightConstraint.constant = 120
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                
                self.tableView.reloadData()
            }
        }*/
        
        refreshDatePicker(false)
        refreshViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //       return UITableViewAutomaticDimension
        let type:kMedicineContentCell = kMedicineContentCell(rawValue: indexPath.row)!
        
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
        case .ParentCell:
            return 96
        case .StarOrExclamation:
            return 96
        case .Camera:
            
            if settingData.bottleImage != nil {
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
        let type:kMedicineContentCell = kMedicineContentCell(rawValue: indexPath.row)!
        
        switch (type){
        case .TimeLeft:
            if bIsVisibleTimePicker{
                settingData.time = t.timeIntervalSinceReferenceDate
            }
            refreshDatePicker(!bIsVisibleTimePicker)
            refreshViews()
            //        case .Interval:
            //            refreshViews()
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
            settingData.Quantity = row
            lblQuantityResult.text = "\(row)"
            refreshQuantityPicker(!isVisibleQuantityPicker)
            refreshViews()
             checkItemChanged()
        }
    }
}
