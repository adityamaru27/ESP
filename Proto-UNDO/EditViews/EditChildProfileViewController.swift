//
//  NewChildProfileViewController.swfit
//  NewChildProfileViewController
//
//  Created by Tomasz on 10/19/15.
//  Copyright © 2015 Tomasz. All rights reserved.
//
enum kEditChildContentCell : Int {
    case SplitterFirst = 0
    case FirstNameCell
    case LastNameCell
    case DOBCell
    case DateTimePicker
    case MeasurementsTitleCell
    case LatestMeasurementsCell
    case VaccinesTitleCell
    case LatestVaccinesCell
    case SplitterLast
    case DeleteCell
}
import UIKit
import Parse

class EditChildProfileViewController: UITableViewController,  UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIAlertViewDelegate  {
    
    var isFirstLoad : Bool = true
    
    var isGetMeasurements : Bool = false
    var isGetVaccines : Bool = false
    
    var bIsVisibleTimePicker:Bool = false
    var bIsCancel: Bool = false
    
    var measurementsArray : [PFObject]! = []
    var vaccinesArray : [PFObject]! = []
    
    @IBOutlet weak var lblLatestMeasurements: UILabel!
    @IBOutlet weak var lblLatestVaccines: UILabel!
    //===============================================
    
    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var txtDOB: UITextField!
    
    //============================================
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // Activity Indicator
    var waitingView : UIView!
    var waitingLabel : UILabel!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnDelete.clipsToBounds = true
        btnDelete.layer.cornerRadius = 13
        
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.addTarget(self, action: #selector(EditChildProfileViewController.datePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditChildProfileViewController.onPressCancel(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditChildProfileViewController.onPressDone(_:)))
        
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        // WaitingView for Create Acccount
        waitingLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 25)) as UILabel!
        waitingLabel.text = "Saving Editing"
        waitingLabel.textAlignment = NSTextAlignment.Center
        waitingLabel.textColor = UIColor.blackColor()
        waitingLabel.font = UIFont.boldSystemFontOfSize(20)
        
        let waitingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        waitingIndicator.color = UIColor.darkGrayColor()
        waitingIndicator.startAnimating()
        
        waitingView = UIView(frame: UIScreen.mainScreen().bounds)
        waitingView.backgroundColor =  UIColor(white: 1.0, alpha: 0.9)
        
        waitingView.addSubview(waitingLabel)
        waitingView.addSubview(waitingIndicator)
        
        waitingIndicator.center = waitingView.center
        waitingLabel.center = CGPointMake(waitingView.center.x, waitingView.center.y - waitingIndicator.bounds.size.height / 2 - waitingLabel.bounds.size.height / 2 - 20)

        measurementsArray = nil
        vaccinesArray = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFirstLoad == true
        {
            txtFirstName.text = currentChild["child_firstname"] as? String
            txtLastName.text = currentChild["child_lastname"] as? String
            txtDOB.text = currentChild["child_dob"] as? String
            
            var child_fullname : String = txtFirstName.text!
            if txtFirstName.text != ""
            {
                child_fullname += " "
            }
            if txtLastName.text != ""
            {
                child_fullname += txtLastName.text!.substringToIndex(txtLastName.text!.startIndex.successor())
            }
            
            self.title = child_fullname
            isFirstLoad = false
        }
        
        self.lblLatestMeasurements.textColor = UIColor.lightGrayColor()
        self.lblLatestMeasurements.text = "None Yet"
        waitingLabel.text = "Getting Details"
        appDelegate.window?.addSubview(waitingView)
        let measurements = PFQuery(className:"measurements")
        
        measurements.whereKey("child", equalTo: currentChild)
        measurements.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            self.isGetMeasurements = true
            if self.isGetVaccines == true
            {
                self.waitingView.removeFromSuperview()
            }
            
            if (error == nil)
            {
                if let objects = objects {
                    if self.txtFirstName.text != "" && self.txtLastName.text != "" && self.txtDOB.text != "" && self.measurementsArray != nil && self.measurementsArray != (objects)
                    {
                        self.navigationItem.rightBarButtonItem?.enabled = true
                    }
                    self.measurementsArray = objects
                }
                
                
                
                if self.measurementsArray != nil && self.measurementsArray.count > 0
                {
                    let latestMeasurements = self.measurementsArray[0]
                    let date = latestMeasurements.objectForKey("date") as! String
                    let weight = latestMeasurements.objectForKey("weight") as! String
                    let length = latestMeasurements.objectForKey("length") as! String
                    let head = latestMeasurements.objectForKey("head_circumference") as! String
                    
                    self.lblLatestMeasurements.textColor = UIColor.blackColor()
                    self.lblLatestMeasurements.text = date + " :: " + weight + ", " + length + ", " + head
                }
            }
        })
        
        self.lblLatestMeasurements.textColor = UIColor.lightGrayColor()
        self.lblLatestVaccines.text = "None Yet"
        appDelegate.window?.addSubview(waitingView)
        let vaccines = PFQuery(className:"vaccines")
        
        vaccines.whereKey("child", equalTo: currentChild)
        vaccines.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            self.isGetVaccines = true
            if self.isGetMeasurements == true
            {
                self.waitingView.removeFromSuperview()
            }
            
            if (error == nil)
            {
                if let objects = objects{
                    if self.txtFirstName.text != "" && self.txtLastName.text != "" && self.txtDOB.text != "" && self.vaccinesArray != nil && self.vaccinesArray != (objects)
                    {
                        self.navigationItem.rightBarButtonItem?.enabled = true
                    }
                }
                
                if let objects = objects {
                    self.vaccinesArray = objects

                }
                if self.vaccinesArray != nil && self.vaccinesArray.count > 0
                {
                    let latestVaccines = self.vaccinesArray[0]
                    let date = latestVaccines.objectForKey("date") as! String
                    let vaccineName = latestVaccines.objectForKey("vaccine") as! String
                    
                    self.lblLatestVaccines.textColor = UIColor.blackColor()
                    self.lblLatestVaccines.text = date + " :: " + vaccineName
                }
            }
        })


    }
    
    // MARK: - IBAction slot
    
    func onPressDone(sender: AnyObject) {
        
        waitingLabel.text = "Saving Editing"
        appDelegate.window?.addSubview(waitingView)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            
            currentChild["child_firstname"] = self.txtFirstName.text
            currentChild["child_lastname"] = self.txtLastName.text
            currentChild["child_dob"] = self.txtDOB.text
            
            do {
            try currentChild.save()
            } catch{
                print(error)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.waitingView.removeFromSuperview()
                self.navigationController?.popViewControllerAnimated(true);
                //                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
        });
        
    }
    
    @IBAction func onPressDelete(sender: AnyObject) {
        
        bIsCancel = false;
        UIAlertView(title: "Are you sure you want to delete this profile?", message: "", delegate: self, cancelButtonTitle: "Dismiss", otherButtonTitles:"Delete").show()
        
    }
    
    func onPressCancel(sender: AnyObject) {
        if self.navigationItem.rightBarButtonItem?.enabled == false
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            bIsCancel = true;
            UIAlertView(title: "Are you sure you want cancel?", message: "You will lose your changes", delegate: self, cancelButtonTitle: "Dismiss", otherButtonTitles:"Cancel").show()
        }
    }
    
    // MARK: - Previous Code
    func datePickerValueChanged(sender: UIDatePicker)
    {
        //        let userDefaults = NSUserDefaults .standardUserDefaults()
        //        let childProflie = userDefaults.objectForKey("child_profile") as! NSDictionary
        txtDOB.text = dateFormatter.stringFromDate(datePicker.date);
        
        if txtFirstName.text != "" || txtLastName.text != ""
        {
            self.navigationItem.rightBarButtonItem?.enabled = true
            
            if txtDOB.text != currentChild["dob"] as? String
            {
                self.navigationItem.rightBarButtonItem?.enabled = true
            }
            else if txtFirstName.text == currentChild["firstname"] as? String && txtLastName.text == currentChild["lastname"] as? String
            {
                self.navigationItem.rightBarButtonItem?.enabled = false
            }
        }
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
        let type:kEditChildContentCell = kEditChildContentCell(rawValue: indexPath.row)!
        
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
        case .DeleteCell:
            return 57;
        case .MeasurementsTitleCell:
            return 50
        case .LatestMeasurementsCell:
            return 45
        case .VaccinesTitleCell:
            return 40
        case .LatestVaccinesCell:
            return 45
        case .SplitterFirst:
            return 35
        case .SplitterLast:
            return 35
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let type:kEditChildContentCell = kEditChildContentCell(rawValue: indexPath.row)!
        
        switch (type){
        case .DOBCell:
            self.view.endEditing(true)
            refreshDatePicker(!bIsVisibleTimePicker)
            tableView.reloadData()
        case .LatestMeasurementsCell:
            let storyboard : UIStoryboard = UIStoryboard(name: "MeasurementsVaccines", bundle: nil)
            let measurementsVC = storyboard.instantiateViewControllerWithIdentifier("MeasurementsView") as! MeasurementsViewController
            measurementsVC.measuresArray = measurementsArray
            measurementsVC.measuresTempArray = measurementsArray
            measurementsVC.isExistingChild = true
            self.navigationController?.pushViewController(measurementsVC, animated: true)
            break
        case .LatestVaccinesCell:
            let storyboard : UIStoryboard = UIStoryboard(name: "MeasurementsVaccines", bundle: nil)
            let vaccinesVC = storyboard.instantiateViewControllerWithIdentifier("VaccinesView") as! VaccinesViewController
            vaccinesVC.vaccinesArray = vaccinesArray
            vaccinesVC.vaccinesTempArray = vaccinesArray
            vaccinesVC.isExistingChild = true
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
    
    // MARK: TextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var isValid : Bool = false
        
        var textString : String = textField.text!
        textString = textString.stringByReplacingCharactersInRange((textField.text?.rangeFromNSRange(range))!, withString: string)
        
        if textString != ""
        {
            isValid = true
        }
        
        if (txtFirstName != textField && txtFirstName.text != "") || (txtLastName != textField && txtLastName.text != "")
        {
            isValid = true
        }
        
        if (txtFirstName != textField && txtFirstName.text != currentChild["firstname"] as? String) ||
            (txtLastName != textField && txtLastName.text != currentChild["lastname"] as? String)
        {
            isValid = true
        }
        
        
        if (txtFirstName != textField && txtFirstName.text == currentChild["firstname"] as? String && textString == currentChild["lastname"] as? String) ||
            (txtLastName != textField && txtLastName.text == currentChild["lastname"] as? String && textString == currentChild["firstname"] as? String)
        {
            isValid = false
        }
        
        if txtDOB.text == ""
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
        
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func showMessage(title :String,  message : String)
    {
        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Dismiss").show()
    }
    
    // MARK: UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1
        {
            if bIsCancel == true{
                navigationController?.popViewControllerAnimated(true)
            }
            else
            {
                waitingLabel.text = "Deleting"
                appDelegate.window?.addSubview(waitingView)
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    
                    
                    
                        
                    
                    let query = PFQuery(className: kLog)
                    query.whereKey(kChild, equalTo: currentChild!)
                    
                    var error : NSError?
                    do{
                    let logObjects : [PFObject] = try query.findObjects() as! [PFObject]
                    if error == nil
                    {
                        do{
                        
                        for logObj in logObjects
                        {
                            try logObj.delete()
                            logObj.saveInBackgroundWithBlock(nil)
                        }
                        
                        } catch let e as NSError?{
                            
                        }
                        
                            
                        
                    }
                        
                    } catch let e as NSError?{
                        
                    }
                    
                    
                    let shareQuery = PFQuery(className:"share")
                    shareQuery.whereKey("inviting_child", equalTo: currentChild!)
                    do{
                    let shareObjects : [PFObject] = try shareQuery.findObjects() as! [PFObject]
                    
                        
                    if error == nil
                    {
                        do{
                        
                        for shareObj in shareObjects
                        {
                            try shareObj.delete()
                            shareObj.saveInBackgroundWithBlock(nil)
                        }
                        
                        } catch let e as NSError?{
                            
                        }
                            
                        
                    }
                    } catch let e as NSError?{
                        
                    }
                    do{
                        
                    try currentChild.delete()
                        
                    } catch let e as NSError?{
                        
                    }
                    currentChild.saveInBackgroundWithBlock(nil)
                    
                    let childQuery = PFQuery(className:"children")
                    
                    childQuery.whereKey("parent", equalTo: PFUser.currentUser()!)
                    
                    childQuery.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                        self.waitingView.removeFromSuperview()
                        
                        if let error = error
                        {
                            let errorString = error.userInfo["error"] as! NSString
                            UIAlertView(title: "", message: errorString as String, delegate: self, cancelButtonTitle: "Dismiss").show()
                        }
                        else
                        {
                            if objects == nil || objects?.count == 0
                            {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.waitingView.removeFromSuperview()
//                                    NSNotificationCenter.defaultCenter().postNotificationName("Child_Removed_Notification", object: nil)
                                    currentChild = nil
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                })
                            }
                            else
                            {
                                if let objects=objects{
                                    currentChild = (objects)[0]
                                }
                                
                                currentChild["active"] = true
                                currentChild.saveInBackgroundWithBlock(nil)
                                self.navigationController?.popToRootViewControllerAnimated(true)
                            }
                            
                        }
                        
                        
                                        })
                        
                   
                    
                })
                
            }
        }
    }
    
}
