//
//  MeasurementsViewController.swift
//  Proto-UNDO
//
//  Created by Tomasz on 11/7/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit
import Parse

class MeasurementsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {

    @IBOutlet weak var btnManage: UIButton!
    @IBOutlet weak var btnAddSet: UIButton!
    @IBOutlet weak var btnRemoveSet: UIButton!
    @IBOutlet weak var manageWrapView: UIView!
    @IBOutlet weak var tblMeasurements: UITableView!
    
    var isExistingChild : Bool = false
    var isRemoveMessage : Bool = false
    var dataCount : Int = 0
    var selectedIndex : Int = -1
    
    var measuresList :  [NSDictionary]! = []
    var measuresArray : [PFObject]! = []
    var measuresTempArray : [PFObject]! = []
    
    // Activity Indicator
    var waitingView : UIView!
    var waitingLabel : UILabel!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("onPressBack:"))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MeasurementsViewController.onPressBack(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MeasurementsViewController.onPressDone(_:)))
        
        self.title = "Measurements"
        
        btnManage.clipsToBounds = true
        btnManage.layer.cornerRadius = btnManage.bounds.size.width / 2
        
        btnAddSet.clipsToBounds = true
        btnAddSet.layer.cornerRadius = 5
        btnAddSet.layer.borderColor = UIColor.lightGrayColor().CGColor
        btnAddSet.layer.borderWidth = 1;
        
        btnRemoveSet.clipsToBounds = true
        btnRemoveSet.layer.cornerRadius = 5
        btnRemoveSet.layer.borderColor = UIColor.lightGrayColor().CGColor
        btnRemoveSet.layer.borderWidth = 1;
        
        manageWrapView.hidden = true
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let measurements = userDefaults.arrayForKey("Measurements")
        if measurements != nil
        {
            measuresList = measurements as! [NSDictionary]
        }
        
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MeasurementsViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MeasurementsViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if isExistingChild == true
        {
            if measuresArray == nil
            {
                return 0
            }
            
            return measuresArray.count
        }
        
        return measuresList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isExistingChild == true
        {
            let measurementObj = measuresArray[indexPath.section] 
            
            switch (indexPath.row)
            {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("MeasurementsTitleCell")
                
                cell?.userInteractionEnabled = (indexPath.section == 0)
                return cell!
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("DateTableViewCell") as! DateTableViewCell
                if (indexPath.section == selectedIndex)
                {
                    cell.isSelected = true
                }
                else
                {
                    cell.isSelected = false
                }
                
                cell.txtDate.text = measurementObj["date"] as? String
                cell.userInteractionEnabled = (indexPath.section == 0)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCellWithIdentifier("NumberInputTableViewCell") as! NumberInputTableViewCell
                cell.lblTitle.text = "Weight"
                cell.cellType = NumberType.WEIGHT_TYPE
                cell.lblBottomSeparator.hidden = true
                
                cell.lblUnit.text = "lb"
                cell.txtInput.text = measurementObj["weight"] as? String
                cell.userInteractionEnabled = (indexPath.section == 0)
                return cell
            case 3:
                let cell = tableView.dequeueReusableCellWithIdentifier("NumberInputTableViewCell") as! NumberInputTableViewCell
                cell.lblTitle.text = "Length"
                cell.cellType = NumberType.LENGTH_TYPE
                cell.lblBottomSeparator.hidden = true
                
                cell.lblUnit.text = "in"
                cell.txtInput.text = measurementObj["length"] as? String
                cell.userInteractionEnabled = (indexPath.section == 0)
                return cell
            case 4:
                let cell = tableView.dequeueReusableCellWithIdentifier("NumberInputTableViewCell") as! NumberInputTableViewCell
                cell.lblTitle.text = "Head Circumference"
                cell.cellType = NumberType.HEAD_CIRCUMFERENCE_TYPE
                cell.lblBottomSeparator.hidden = false
                
                cell.lblUnit.text = "in"
                cell.txtInput.text = measurementObj["head_circumference"] as? String
                cell.userInteractionEnabled = (indexPath.section == 0)
                return cell
            default:
                return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "DefaultCell")
            }

        }
        else
        {
            let measurementObj = measuresList[indexPath.section]
            
            switch (indexPath.row)
            {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("MeasurementsTitleCell")
                
                cell?.userInteractionEnabled = (indexPath.section == 0)
                return cell!
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("DateTableViewCell") as! DateTableViewCell
                if (indexPath.section == selectedIndex)
                {
                    cell.isSelected = true
                }
                else
                {
                    cell.isSelected = false
                }
                
                cell.txtDate.text = measurementObj.objectForKey("Date") as? String
                cell.userInteractionEnabled = (indexPath.section == 0)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCellWithIdentifier("NumberInputTableViewCell") as! NumberInputTableViewCell
                cell.lblTitle.text = "Weight"
                cell.cellType = NumberType.WEIGHT_TYPE
                cell.lblBottomSeparator.hidden = true
                
                cell.lblUnit.text = "lb"
                cell.txtInput.text = measurementObj.objectForKey("Weight") as? String
                cell.userInteractionEnabled = (indexPath.section == 0)
                return cell
            case 3:
                let cell = tableView.dequeueReusableCellWithIdentifier("NumberInputTableViewCell") as! NumberInputTableViewCell
                cell.lblTitle.text = "Length"
                cell.cellType = NumberType.LENGTH_TYPE
                cell.lblBottomSeparator.hidden = true
                
                cell.lblUnit.text = "in"
                cell.txtInput.text = measurementObj.objectForKey("Length") as? String
                cell.userInteractionEnabled = (indexPath.section == 0)
                return cell
            case 4:
                let cell = tableView.dequeueReusableCellWithIdentifier("NumberInputTableViewCell") as! NumberInputTableViewCell
                cell.lblTitle.text = "Head Circumference"
                cell.cellType = NumberType.HEAD_CIRCUMFERENCE_TYPE
                cell.lblBottomSeparator.hidden = false
                
                cell.lblUnit.text = "in"
                cell.txtInput.text = measurementObj.objectForKey("Head") as? String
                cell.userInteractionEnabled = (indexPath.section == 0)
                return cell
            default:
                return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "DefaultCell")
            }
        }

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.row)
        {
        case 0:
            if indexPath.section == 0
            {
                return 45
            }
            return 40
        case 1:
            if selectedIndex == indexPath.section
            {
                return 205
            }
            return 45
        default:
            return 45
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 1
        {
            self.view.endEditing(true)
            let dateCell = tableView .cellForRowAtIndexPath(indexPath) as! DateTableViewCell
            dateCell.isSelected = !dateCell.isSelected
            if dateCell.isSelected == true
            {
                selectedIndex = indexPath.section
            }
            else
            {
                selectedIndex = -1
            }
            
            var t = NSDate()
            if dateCell.txtDate.text != ""
            {
                t = dateCell.dateFormatter.dateFromString(dateCell.txtDate.text!)!
            }
            else
            {
                dateCell.txtDate.text = dateCell.dateFormatter.stringFromDate(t)
            }
            dateCell.datePicker.setDate(t, animated: true)
            
            updateLatestMeasurements()
            tblMeasurements.reloadData()
        }
    }
    
    // MARK: - Actions

    @IBAction func onPressManage(sender: AnyObject) {
        self.view.endEditing(true)
        manageWrapView.hidden = !manageWrapView.hidden
        if manageWrapView.hidden == true
        {
            btnManage.setTitle("+", forState: UIControlState.Normal)
        }
        else
        {
            btnManage.setTitle("−", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func onPressAddSet(sender: AnyObject) {
        self.onPressManage(btnManage)
        
        if isExistingChild == true
        {
            if measuresArray.count > 0
            {
                updateLatestMeasurements()
                if isLatestMeasurementsFullyInputed() == false
                {
                    UIAlertView(title: "", message: "You need to input all fields", delegate: nil, cancelButtonTitle: "Dismiss").show()
                    return
                }
            }
            
            let measurementObj = PFObject(className: "measurements")
            measurementObj["child"] = currentChild
            measurementObj["date"] = ""
            measurementObj["weight"] = ""
            measurementObj["length"] = ""
            measurementObj["head_circumference"] = ""
            measuresArray.insert(measurementObj, atIndex: 0)
        }
        else
        {
            if measuresList.count > 0
            {
                updateLatestMeasurements()
                if isLatestMeasurementsFullyInputed() == false
                {
                    UIAlertView(title: "", message: "You need to input all fields", delegate: nil, cancelButtonTitle: "Dismiss").show()
                    return
                }
            }
            
            let measurementObj : NSDictionary!
            measurementObj = NSDictionary(objects: ["", "", "", ""], forKeys: ["Date", "Weight", "Length", "Head"])
            measuresList.insert(measurementObj, atIndex: 0)
        }
        
        tblMeasurements.reloadData()
    }
   
    @IBAction func onPressRemoveSet(sender: AnyObject) {
        if isExistingChild == true
        {
            if measuresArray.count > 0
            {
                isRemoveMessage = true
                UIAlertView(title: "Are you sure to remove \n latest measurements?", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles:"OK").show()
            }
        }
        else
        {
            if measuresList.count > 0
            {
                isRemoveMessage = true
                UIAlertView(title: "Are you sure to remove \n latest measurements?", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles:"OK").show()
            }
        }
        self.onPressManage(btnManage)
    }
    
    func onPressDone(sender : AnyObject)
    {
        self.view.endEditing(true)
        
        if isLatestMeasurementsFullyInputed() == false
        {
            UIAlertView(title: "", message: "You need to input all fields", delegate: nil, cancelButtonTitle: "Dismiss").show()
            return
        }

        
        if isExistingChild == true
        {
            appDelegate.window?.addSubview(waitingView)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                if self.measuresArray.count > 0
                {
                    self.updateLatestMeasurements()
                    if self.isLatestMeasurementsFullyInputed() == false
                    {
                        UIAlertView(title: "", message: "You need to input all fields", delegate: nil, cancelButtonTitle: "Dismiss").show()
                        return
                    }
                    
                    let measurementsQurey = PFQuery(className:"measurements")
                    measurementsQurey.whereKey("child", equalTo: currentChild)
                    do{
                        
                    
                        
                         let measurements = try measurementsQurey.findObjects()
                            
                        
                        do {
                            for measureObj in measurements
                            {
                                try measureObj.delete()
                            }
                        } catch {
                            print(error)
                        }
                        
                    } catch{
                        print(error)
                    }
                    
                    
                    for measureObj in self.measuresArray
                    {
                        do {
                        let measuresObject = PFObject(className:"measurements")
                        measuresObject["child"] = currentChild
                        measuresObject["date"] = measureObj["date"]
                        measuresObject["weight"] = measureObj["weight"]
                        
                        measuresObject["length"] = measureObj["length"]
                        measuresObject["head_circumference"] = measureObj["head_circumference"]
                        
                        try measuresObject.save()
                        }catch{
                            print(error)
                        }
                        
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.waitingView.removeFromSuperview()
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }
                else
                {
                    let measurementsQurey = PFQuery(className:"measurements")
                    measurementsQurey.whereKey("child", equalTo: currentChild)
                    do {
                        
                    let measurements = try measurementsQurey.findObjects() as? [PFObject]
                    if (measurements != nil)
                    {
                        for measureObj in measurements!
                        {
                            try measureObj.delete()
                        }
                    }
                    } catch {
                        print(error)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.waitingView.removeFromSuperview()
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }

            })
        }
        else
        {
            if measuresList.count > 0
            {
                updateLatestMeasurements()
                if isLatestMeasurementsFullyInputed() == false
                {
                    UIAlertView(title: "", message: "You need to input all fields", delegate: nil, cancelButtonTitle: "Dismiss").show()
                    return
                }

                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(measuresList, forKey: "Measurements")
                userDefaults.synchronize()
            }
            else
            {
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(nil, forKey: "Measurements")
                userDefaults.synchronize()
            }
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func onPressBack(sender : AnyObject)
    {
        var isExistChanges : Bool = false
        
        if isExistingChild == true
        {
            if measuresArray != measuresTempArray
            {
                isExistChanges = true
            }
        }
        else
        {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let measurements = userDefaults.arrayForKey("Measurements")
            var list : [NSDictionary] = []
            if measurements != nil
            {
                list = measurements as! [NSDictionary]
            }
            
            if list != measuresList
            {
                isExistChanges = true
            }

        }
        
        if isExistChanges == false
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            let alertController = UIAlertController(title: nil, message: "Are you sure to \"Cancel\"?\nThe event will be deleted", preferredStyle: .ActionSheet)
            
            let deleteAction = UIAlertAction(title: "Yes, cancel and delete", style: .Destructive){ (action) in
                self.navigationController?.popViewControllerAnimated(true);
            }
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "No, don't delete", style: .Cancel){ (action) in
            }
            alertController.addAction(cancelAction)
            
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
            {
                alertController.popoverPresentationController?.sourceView = self.view
                alertController.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 49, 1.0, 1.0)
            }
            
            presentViewController(alertController, animated: true){}
        }

    }
    
    func updateLatestMeasurements()
    {
        if isExistingChild == true
        {
            if measuresArray == nil || measuresArray.count == 0
            {
                return
            }
            
            let latestMeasurements = PFObject(className: "measurements")
            latestMeasurements["child"] = currentChild
            
            let dateIndexPath = NSIndexPath(forRow: 1, inSection: 0)
            if let dateCell = tblMeasurements.cellForRowAtIndexPath(dateIndexPath) as? DateTableViewCell
            {
                latestMeasurements["date"] = dateCell.txtDate.text!
            }
            
            let weightIndexPath = NSIndexPath(forRow: 2, inSection: 0)
            if let weightCell = tblMeasurements.cellForRowAtIndexPath(weightIndexPath) as? NumberInputTableViewCell
            {
                latestMeasurements["weight"] = weightCell.txtInput.text!
            }
            
            let lengthIndexPath = NSIndexPath(forRow: 3, inSection: 0)
            if let lengthCell = tblMeasurements.cellForRowAtIndexPath(lengthIndexPath) as? NumberInputTableViewCell
            {
                latestMeasurements["length"] = lengthCell.txtInput.text!
            }
            
            let headIndexPath = NSIndexPath(forRow: 4, inSection: 0)
            if let headCell = tblMeasurements.cellForRowAtIndexPath(headIndexPath) as? NumberInputTableViewCell
            {
                latestMeasurements["head_circumference"] = headCell.txtInput.text!
            }
            
            measuresArray.removeAtIndex(0)
            measuresArray.insert(latestMeasurements, atIndex: 0)

        }
        else
        {
            if measuresList == nil || measuresList.count == 0
            {
                return
            }
            
            let latestMeasurements = NSMutableDictionary(dictionary: measuresList[0])
            
            let dateIndexPath = NSIndexPath(forRow: 1, inSection: 0)
            if let dateCell = tblMeasurements.cellForRowAtIndexPath(dateIndexPath) as? DateTableViewCell
            {
                latestMeasurements.setObject(dateCell.txtDate.text!, forKey: "Date")
            }
            
            let weightIndexPath = NSIndexPath(forRow: 2, inSection: 0)
            if let weightCell = tblMeasurements.cellForRowAtIndexPath(weightIndexPath) as? NumberInputTableViewCell
            {
                latestMeasurements.setObject(weightCell.txtInput.text!, forKey: "Weight")
            }
            
            let lengthIndexPath = NSIndexPath(forRow: 3, inSection: 0)
            if let lengthCell = tblMeasurements.cellForRowAtIndexPath(lengthIndexPath) as? NumberInputTableViewCell
            {
                latestMeasurements.setObject(lengthCell.txtInput.text!, forKey: "Length")
            }
            
            let headIndexPath = NSIndexPath(forRow: 4, inSection: 0)
            if let headCell = tblMeasurements.cellForRowAtIndexPath(headIndexPath) as? NumberInputTableViewCell
            {
                latestMeasurements.setObject(headCell.txtInput.text!, forKey: "Head")
            }
            
            measuresList.removeAtIndex(0)
            measuresList.insert(latestMeasurements, atIndex: 0)
        
        }
    }
    
    func isLatestMeasurementsFullyInputed() -> Bool
    {
        if isExistingChild == true
        {
            let latestMeasurements = measuresArray[0]
            let date = latestMeasurements["date"] as! String
            let weight = latestMeasurements["weight"] as! String
            let length = latestMeasurements["length"] as! String
            let head = latestMeasurements["head_circumference"] as! String
            
            if date == "" || weight == "" || length == "" || head == ""
            {
                return false
            }
        }
        else
        {
            let latestMeasurements = measuresList[0]
            let date = latestMeasurements.objectForKey("Date") as! String
            let weight = latestMeasurements.objectForKey("Weight") as! String
            let length = latestMeasurements.objectForKey("Length") as! String
            let head = latestMeasurements.objectForKey("Head") as! String
            
            if date == "" || weight == "" || length == "" || head == ""
            {
                return false
            }
        }
        
        return true
    }
    
    // MARK: - Keyboard Notification
    
    func keyboardWillShow(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
                tblMeasurements.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 1, right: 0)
            }
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        updateLatestMeasurements()
        tblMeasurements.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - AlertView
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    
        if buttonIndex == 1
        {
            if isRemoveMessage == true
            {
                if isExistingChild == true
                {
                    measuresArray.removeAtIndex(0)
                }
                else
                {
                    measuresList.removeAtIndex(0)
                }
                tblMeasurements.reloadData()
            }
            else
            {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
}
