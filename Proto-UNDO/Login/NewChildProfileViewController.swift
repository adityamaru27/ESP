//
//  NewChildProfileViewController.swfit
//  NewChildProfileViewController
//
//  Created by Tomasz on 10/19/15.
//  Copyright © 2015 Tomasz. All rights reserved.
//
enum kNewChildContentCell : Int {
    case SplitterFirst = 0
    case ActiveCell
    case SplitterOne
    case FirstNameCell
    case LastNameCell
    case SplitterTwo
    case DOBCell
    case DateTimePicker
    case MeasurementsTitleCell
    case LatestMeasurementsCell
    case VaccinesTitleCell
    case LatestVaccinesCell
}
import UIKit
import Parse

class NewChildProfileViewController: UITableViewController,  UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate  {
    
    var bIsVisibleTimePicker:Bool = false
    var isNewMoreChild : Bool = false
    var isFirstLoad : Bool = true
    
    //===============================================
    
    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var txtDOB: UITextField!
    
    //============================================
    
    @IBOutlet weak var lblLatestMeasurements: UILabel!
    
    @IBOutlet weak var lblLatestVaccines: UILabel!
    
    //============================================
    @IBOutlet weak var activeSwitchControl: UISwitch!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // Activity Indicator
    var waitingView : UIView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate


    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.addTarget(self, action: #selector(NewChildProfileViewController.datePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(NewChildProfileViewController.onPressCancel(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(NewChildProfileViewController.onPressDone(_:)))
        
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        // WaitingView for Create Acccount
        let waitingLabel = UILabel(frame: CGRectZero) as UILabel!
        waitingLabel.text = "Creating Child"
        waitingLabel.textColor = UIColor.blackColor()
        waitingLabel.font = UIFont.boldSystemFontOfSize(20)
        waitingLabel.sizeToFit()
        
        let waitingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        waitingIndicator.color = UIColor.darkGrayColor()
        waitingIndicator.startAnimating()
        
        waitingView = UIView(frame: UIScreen.mainScreen().bounds)
        waitingView.backgroundColor =  UIColor(white: 1.0, alpha: 0.9)
        
        waitingView.addSubview(waitingLabel)
        waitingView.addSubview(waitingIndicator)
        
        waitingIndicator.center = waitingView.center
        waitingLabel.center = CGPointMake(waitingView.center.x, waitingView.center.y - waitingIndicator.bounds.size.height / 2 - waitingLabel.bounds.size.height / 2 - 20)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(nil, forKey: "Measurements")
        userDefaults.setObject(nil, forKey: "Vaccines")
        userDefaults.synchronize()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        if isNewMoreChild == false && isFirstLoad == true
//        {
//            UIAlertView(title: "We need to create a child \n profile to get started", message: "", delegate: nil, cancelButtonTitle: "Begin Profile").show()
//        }
//        isFirstLoad = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let measurements = userDefaults.arrayForKey("Measurements")
        if measurements != nil
        {
            let latestMeasurements = (measurements as! [NSDictionary])[0]
            let date = latestMeasurements.objectForKey("Date") as! String
            let weight = latestMeasurements.objectForKey("Weight") as! String
            let length = latestMeasurements.objectForKey("Length") as! String
            let head = latestMeasurements.objectForKey("Head") as! String
            
            lblLatestMeasurements.textColor = UIColor.blackColor()
            lblLatestMeasurements.text = date + " :: " + weight + ", " + length + ", " + head
        }
        else
        {
            lblLatestMeasurements.textColor = UIColor.lightGrayColor()
            lblLatestMeasurements.text = "None Yet"
        }

        let vaccines = userDefaults.arrayForKey("Vaccines")
        if vaccines != nil
        {
            let latestVaccines = (vaccines as! [NSDictionary])[0]
            let date = latestVaccines.objectForKey("Date") as! String
            let vaccine = latestVaccines.objectForKey("Vaccine") as! String
            
            lblLatestVaccines.textColor = UIColor.blackColor()
            lblLatestVaccines.text = date + " :: " + vaccine
        }
        else
        {
            lblLatestVaccines.textColor = UIColor.lightGrayColor()
            lblLatestVaccines.text = "None Yet"
        }

    }
    
    // MARK: - IBAction slot
    
    func onPressDone(sender: AnyObject) {
        self.view.endEditing(true)
        
        let newChild = PFObject(className:"children")
        
        newChild["child_firstname"] = txtFirstName.text
        newChild["child_lastname"] = txtLastName.text
        newChild["child_dob"] = txtDOB.text
        newChild["parent"] = PFUser.currentUser()
        
        appDelegate.window?.addSubview(waitingView)
        
        newChild.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError? ) -> Void in
            self.waitingView.removeFromSuperview()
            
            if let error = error {
                let errorString = error.userInfo["error"] as! NSString
                self.showMessage("Creating Child Profile Failed", message: errorString as String)
            }else
            {
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                let measurements = userDefaults.arrayForKey("Measurements")
                if measurements != nil
                {
                    for measurementObj in (measurements as! [NSDictionary])
                    {
                        let newMeasurements = PFObject(className:"measurements")
//                        let weight = measurementObj.objectForKey("Weight") as! String
//                        let length = measurementObj.objectForKey("Length") as! String
//                        let head = measurementObj.objectForKey("Head") as! String
                        
                        newMeasurements["child"] = newChild
                        newMeasurements["date"] = measurementObj.objectForKey("Date") as! String
//                        newMeasurements["weight"] = Double(weight.substringToIndex(weight.endIndex.advancedBy(-3)))
//                        newMeasurements["length"] = Double(length.substringToIndex(length.endIndex.advancedBy(-3)))
//                        newMeasurements["head_circumference"] = Double(head.substringToIndex(head.endIndex.advancedBy(-3)))
                        newMeasurements["weight"] = measurementObj.objectForKey("Weight") as! String
                        newMeasurements["length"] = measurementObj.objectForKey("Length") as! String
                        newMeasurements["head_circumference"] = measurementObj.objectForKey("Head") as! String

                        
                        newMeasurements.saveInBackgroundWithBlock(nil)
                    }
                }

                let vaccines = userDefaults.arrayForKey("Vaccines")
                if vaccines != nil
                {
                    for vaccineObj in (vaccines as! [NSDictionary])
                    {
                        let newVaccines = PFObject(className:"vaccines")
                        
                        newVaccines["child"] = newChild
                        newVaccines["date"] = vaccineObj.objectForKey("Date") as! String
                        newVaccines["vaccine"] = vaccineObj.objectForKey("Vaccine") as! String
                        
                        newVaccines.saveInBackgroundWithBlock(nil)
                    }
                }

                if self.isNewMoreChild == false
                {
                    currentChild = newChild
                    
                    DataSource.sharedDataSouce
                    EventsManager.sharedManager
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
//                    let fileName = NSProcessInfo.processInfo().globallyUniqueString + ".csv"
//                    let tempDir : NSString = NSTemporaryDirectory() as NSString
//                    let logFilePath = tempDir.stringByAppendingPathComponent(fileName)
//                    
//                    logFileURL = NSURL(fileURLWithPath: logFilePath)
//                    let fileManager = NSFileManager()
//                    
//                    if fileManager.fileExistsAtPath(logFilePath) == false
//                    {
//                        fileManager.createFileAtPath(logFilePath, contents: nil, attributes: nil)
//                    }
//                    
//                    currentChild = newChild
//                    
//                    DataSource.sharedDataSouce
//                    EventsManager.sharedManager
//
//                    let navVC = UINavigationController(rootViewController: viewController)
//                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let logVC = storyboard.instantiateViewControllerWithIdentifier("LogsNavController")
//                    let collaborateVC = UIStoryboard(name: "Collaborate", bundle: nil).instantiateViewControllerWithIdentifier("CollaborateNavView")
//                    let inviteVC = storyboard.instantiateViewControllerWithIdentifier("InviteViewController")
//                    
//                    tabContentVC = UITabBarController()
//                    tabContentVC.viewControllers = [navVC, logVC, collaborateVC, inviteVC]
//                    self.presentViewController(tabContentVC, animated: true, completion: { () -> Void in
//                        self.navigationController?.popViewControllerAnimated(false)
//                    })
                }
                else
                {
                    if self.activeSwitchControl.on == true
                    {
                        newChild["active"] = true
                        currentChild = newChild
                        currentChild.saveInBackgroundWithBlock(nil)
                    }
                    
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
    }
    
    func onPressCancel(sender: AnyObject) {
        
        if isNewMoreChild == true
        {
            navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - Previous Code
    func datePickerValueChanged(sender: UIDatePicker)
    {
        self.view.endEditing(true)
        txtDOB.text = dateFormatter.stringFromDate(datePicker.date);
    }
    
    lazy var dateFormatter : NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter
        }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //       return UITableViewAutomaticDimension
        let type:kNewChildContentCell = kNewChildContentCell(rawValue: indexPath.row)!
        
        switch(type)
        {
        case .FirstNameCell:
            return 45
        case .LastNameCell:
            return 45
        case .DOBCell:
            return 45
        case .DateTimePicker:
            if bIsVisibleTimePicker == false {
                return 0
            }
            return 160
        case .ActiveCell:
            if isNewMoreChild == false
            {
                return 0
            }
            
            return 45
        case .SplitterFirst:
            return 35
        case .MeasurementsTitleCell:
            return 50
        case .LatestMeasurementsCell:
            return 45
        case .VaccinesTitleCell:
            return 40
        case .LatestVaccinesCell:
            return 40
        case .SplitterOne:
            if isNewMoreChild == false
            {
                return 0
            }

            return 20
        case .SplitterTwo:
            return 20
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let type:kNewChildContentCell = kNewChildContentCell(rawValue: indexPath.row)!
        
        switch (type){
        case .DOBCell:
            self.view.endEditing(true)
            refreshDatePicker(!bIsVisibleTimePicker)
            
            tableView.reloadData()
        case .LatestMeasurementsCell:
            let storyboard : UIStoryboard = UIStoryboard(name: "MeasurementsVaccines", bundle: nil)
            let measurementsVC = storyboard.instantiateViewControllerWithIdentifier("MeasurementsView")
            self.navigationController?.pushViewController(measurementsVC, animated: true)
            break
        case .LatestVaccinesCell:
            let storyboard : UIStoryboard = UIStoryboard(name: "MeasurementsVaccines", bundle: nil)
            let vaccinesVC = storyboard.instantiateViewControllerWithIdentifier("VaccinesView")
            self.navigationController?.pushViewController(vaccinesVC, animated: true)
            break
        default:
            tableView.reloadData()
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
    
    func refreshDatePicker(isExpand:Bool){
        var t = NSDate()
        if txtDOB.text != ""
        {
            t = dateFormatter.dateFromString(txtDOB.text!)!
        }
        else
        {
            txtDOB.text = dateFormatter.stringFromDate(t)
            if txtFirstName.text != "" && txtLastName.text != ""
            {
                self.navigationItem.rightBarButtonItem?.enabled = true
            }
        }

        datePicker.setDate(t, animated: true)
        bIsVisibleTimePicker = isExpand
    }
    
    func showMessage(title :String,  message : String)
    {
        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Dismiss").show()
    }
    
    // MARK: - TextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var isValid : Bool = true
        
        var textString : String = textField.text!
        textString = textString.stringByReplacingCharactersInRange((textField.text?.rangeFromNSRange(range))!, withString: string)
        
        if textString == ""
        {
            isValid = false
        }
        else if (txtFirstName != textField && txtFirstName.text == "") || (txtLastName != textField && txtLastName.text == "")
        {
            isValid = false
        }
        else if txtDOB.text == ""
        {
            isValid = false
        }
        
        if isValid
        {
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
        else
        {
            self.navigationItem.rightBarButtonItem?.enabled = false
        }

        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == ""
        {
            textField.clearButtonMode = UITextFieldViewMode.WhileEditing
        }
        else
        {
            textField.clearButtonMode = UITextFieldViewMode.Always
        }
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        self.navigationItem.rightBarButtonItem?.enabled = false
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return true
    }
    
    // MARK: - SwitchControl
    
    @IBAction func onActiveSwitchChanged(sender: AnyObject)
    {
        
    }
}
