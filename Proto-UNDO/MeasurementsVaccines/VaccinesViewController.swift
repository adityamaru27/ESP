//
//  VaccinesViewController.swift
//  Proto-UNDO
//
//  Created by Tomasz on 11/9/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit
import Parse

class VaccinesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    
    @IBOutlet weak var btnManage: UIButton!
    @IBOutlet weak var btnAddSet: UIButton!
    @IBOutlet weak var btnRemoveSet: UIButton!
    @IBOutlet weak var manageWrapView: UIView!
    @IBOutlet weak var tblVaccines: UITableView!
    
    var isExistingChild : Bool = false
    var dataCount : Int = 0
    var selectedIndex : Int = -1
    var isRemoveMessage : Bool = false
    
    var vaccinesList :  [NSDictionary]! = []
    var vaccinesArray : [PFObject]! = []
    var vaccinesTempArray : [PFObject]! = []
    
    // Activity Indicator
    var waitingView : UIView!
    var waitingLabel : UILabel!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(VaccinesViewController.onPressBack(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(VaccinesViewController.onPressDone(_:)))
        
        self.title = "Vaccines"
        
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VaccinesViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VaccinesViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(nil, forKey: "SelectedVaccine")
        userDefaults.synchronize()
        
        let vaccines = userDefaults.arrayForKey("Vaccines")
        if vaccines != nil
        {
            vaccinesList = vaccines as! [NSDictionary]
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VaccinesViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VaccinesViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let selectedVaccine = userDefaults.objectForKey("SelectedVaccine")
        {
            updateLatestVaccines()
            if isExistingChild == true
            {
                let latestVaccines = vaccinesArray[0]
                latestVaccines["vaccine"] = selectedVaccine
                vaccinesArray.removeAtIndex(0)
                vaccinesArray.insert(latestVaccines, atIndex: 0)
            }
            else
            {
                let latestVaccines = NSMutableDictionary(dictionary: vaccinesList[0])
                latestVaccines.setObject(selectedVaccine, forKey: "Vaccine")
                vaccinesList.removeAtIndex(0)
                vaccinesList.insert(latestVaccines, atIndex: 0)
            }
            tblVaccines.reloadData()
        }

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
            if vaccinesArray == nil
            {
                return 0
            }
            
            return vaccinesArray.count
        }

        return vaccinesList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isExistingChild == true
        {
            let vaccineObj = vaccinesArray[indexPath.section]
            
            switch (indexPath.row)
            {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("VaccinesTitleCell")
                
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
                
                cell.txtDate.text = vaccineObj["date"] as? String
                cell.userInteractionEnabled = (indexPath.section == 0)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCellWithIdentifier("VaccineTableViewCell") as! VaccineTableViewCell
                
                cell.txtVaccine.text = vaccineObj["vaccine"] as? String
                cell.userInteractionEnabled = (indexPath.section == 0)
                
                if indexPath.section == 0
                {
                    cell.setCellType(VaccineCellType.INPUT_CELL)
                }
                else
                {
                    cell.setCellType(VaccineCellType.DISPLAY_CELL)
                }
                
                return cell
            default:
                return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "DefaultCell")
            }

        }
        else
        {
            let vaccineObj = vaccinesList[indexPath.section]
            
            switch (indexPath.row)
            {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("VaccinesTitleCell")
                
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
                
                cell.txtDate.text = vaccineObj.objectForKey("Date") as? String
                cell.userInteractionEnabled = (indexPath.section == 0)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCellWithIdentifier("VaccineTableViewCell") as! VaccineTableViewCell
                
                cell.txtVaccine.text = vaccineObj.objectForKey("Vaccine") as? String
                cell.userInteractionEnabled = (indexPath.section == 0)
                
                if indexPath.section == 0
                {
                    cell.setCellType(VaccineCellType.INPUT_CELL)
                }
                else
                {
                    cell.setCellType(VaccineCellType.DISPLAY_CELL)
                }
                
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
            
            updateLatestVaccines()
            tblVaccines.reloadData()
        }
        else if indexPath.row == 2
        {
            let vaccineCell = tableView .cellForRowAtIndexPath(indexPath) as! VaccineTableViewCell
            self.performSegueWithIdentifier("showVaccineSelectionView", sender: vaccineCell.txtVaccine.text)
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
            if vaccinesArray.count > 0
            {
                updateLatestVaccines()
                if isLatestVaccinesFullyInputed() == false
                {
                    UIAlertView(title: "", message: "You need to input all fields", delegate: nil, cancelButtonTitle: "Dismiss").show()
                    return
                }
            }
            
            let vaccineObj = PFObject(className: "vaccines")
            vaccineObj["child"] = currentChild
            vaccineObj["date"] = ""
            vaccineObj["vaccine"] = ""
            vaccinesArray.insert(vaccineObj, atIndex: 0)
        }
        else
        {
            if vaccinesList.count > 0
            {
                updateLatestVaccines()
                if isLatestVaccinesFullyInputed() == false
                {
                    UIAlertView(title: "", message: "You need to input all fields", delegate: nil, cancelButtonTitle: "Dismiss").show()
                    return
                }
            }
            
            let vaccineObj : NSDictionary!
            
            vaccineObj = NSDictionary(objects: ["", ""], forKeys: ["Date", "Vaccine"])
            
            vaccinesList.insert(vaccineObj, atIndex: 0)
        }
        
        tblVaccines.reloadData()
    }
    
    @IBAction func onPressRemoveSet(sender: AnyObject) {
        if isExistingChild == true
        {
            if vaccinesArray.count > 0
            {
                isRemoveMessage = true
                UIAlertView(title: "Are you sure to remove \n latest measurements?", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles:"OK").show()
            }
        }
        else
        {
            if vaccinesList.count > 0
            {
                isRemoveMessage = true
                UIAlertView(title: "Are you sure to remove \n latest vaccines?", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles:"OK").show()
            }
        }
        self.onPressManage(btnManage)
    }
    
    func onPressDone(sender : AnyObject)
    {
        
        if isLatestVaccinesFullyInputed() == false
        {
            UIAlertView(title: "", message: "You need to input all fields", delegate: nil, cancelButtonTitle: "Dismiss").show()
            return
        }


        
        self.view.endEditing(true)
        
        if isExistingChild == true
        {
            appDelegate.window?.addSubview(waitingView)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                
                do {
                if self.vaccinesArray.count > 0
                {
                    self.updateLatestVaccines()
                    if self.isLatestVaccinesFullyInputed() == false
                    {
                        UIAlertView(title: "", message: "You need to input all fields", delegate: nil, cancelButtonTitle: "Dismiss").show()
                        return
                    }
                    
                    let vaccinesQurey = PFQuery(className:"vaccines")
                    vaccinesQurey.whereKey("child", equalTo: currentChild)
                    let vaccines = try  vaccinesQurey.findObjects() as? [PFObject]
                    if (vaccines != nil)
                    {
                        for vaccineObj in vaccines!
                        {
                            try vaccineObj.delete()
                        }
                    }
                    
                    for vaccineObj in self.vaccinesArray
                    {
                       
                        let vaccinesObject = PFObject(className:"vaccines")
                        vaccinesObject["child"] = currentChild
                        vaccinesObject["date"] = vaccineObj["date"]
                        vaccinesObject["vaccine"] = vaccineObj["vaccine"]
                        
                        try vaccinesObject.save()
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.waitingView.removeFromSuperview()
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }
                else
                {
                    let vaccinesQurey = PFQuery(className:"vaccines")
                    vaccinesQurey.whereKey("child", equalTo: currentChild)
                    let vaccines = try vaccinesQurey.findObjects() as? [PFObject]
                    if (vaccines != nil)
                    {
                        for vaccineObj in vaccines!
                        {
                            try vaccineObj.delete()
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.waitingView.removeFromSuperview()
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }
                } catch let error as NSError{
                    
                }
                
            })
        }
        else
        {
            if vaccinesList.count > 0
            {
                updateLatestVaccines()
                if isLatestVaccinesFullyInputed() == false
                {
                    UIAlertView(title: "", message: "You need to input all fields", delegate: nil, cancelButtonTitle: "Dismiss").show()
                    return
                }
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(vaccinesList, forKey: "Vaccines")
                userDefaults.synchronize()
            }
            else
            {
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(nil, forKey: "Vaccines")
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
            if vaccinesArray != vaccinesTempArray
            {
                isExistChanges = true
            }
        }
        else
        {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let vaccines = userDefaults.arrayForKey("Vaccines")
            var list : [NSDictionary] = []
            if vaccines != nil
            {
                list = vaccines as! [NSDictionary]
            }
            
            if list != vaccinesList
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

    
    func updateLatestVaccines()
    {
        if isExistingChild == true
        {
            if vaccinesArray == nil || vaccinesArray.count == 0
            {
                return
            }
            
            let latestVaccines = PFObject(className: "vaccines")
            latestVaccines["child"] = currentChild
            
            let dateIndexPath = NSIndexPath(forRow: 1, inSection: 0)
            if let dateCell = tblVaccines.cellForRowAtIndexPath(dateIndexPath) as? DateTableViewCell
            {
                latestVaccines["date"] = dateCell.txtDate.text!
            }
            
            let vaccineIndexPath = NSIndexPath(forRow: 2, inSection: 0)
            if let vaccineCell = tblVaccines.cellForRowAtIndexPath(vaccineIndexPath) as? VaccineTableViewCell
            {
                latestVaccines["vaccine"] = vaccineCell.txtVaccine.text!
            }
            
            vaccinesArray.removeAtIndex(0)
            vaccinesArray.insert(latestVaccines, atIndex: 0)
            
        }
        else
        {
            if vaccinesList == nil || vaccinesList.count == 0
            {
                return
            }
            
            let latestVaccines = NSMutableDictionary(dictionary: vaccinesList[0])
            
            let dateIndexPath = NSIndexPath(forRow: 1, inSection: 0)
            if let dateCell = tblVaccines.cellForRowAtIndexPath(dateIndexPath) as? DateTableViewCell
            {
                latestVaccines.setObject(dateCell.txtDate.text!, forKey: "Date")
            }
            
            let vaccineIndexPath = NSIndexPath(forRow: 2, inSection: 0)
            if let vaccineCell = tblVaccines.cellForRowAtIndexPath(vaccineIndexPath) as? VaccineTableViewCell
            {
                latestVaccines.setObject(vaccineCell.txtVaccine.text!, forKey: "Vaccine")
            }
            
            vaccinesList.removeAtIndex(0)
            vaccinesList.insert(latestVaccines, atIndex: 0)
        }
    }
    
    func isLatestVaccinesFullyInputed() -> Bool
    {
        if isExistingChild == true
        {
            let latestVaccines = vaccinesArray[0]
            let date = latestVaccines["date"] as! String
            let vaccine = latestVaccines["vaccine"] as! String
            
            if date == "" || vaccine == ""
            {
                return false
            }
        }
        else
        {
            let latestVaccines = vaccinesList[0]
            let date = latestVaccines.objectForKey("Date") as! String
            let vaccine = latestVaccines.objectForKey("Vaccine") as! String
            
            if date == "" || vaccine == ""
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
                tblVaccines.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 1, right: 0)
            }
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        updateLatestVaccines()
        tblVaccines.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - AlertView
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == 1
        {
            if isRemoveMessage == true
            {
                if isExistingChild == true
                {
                    vaccinesArray.removeAtIndex(0)
                }
                else
                {
                    vaccinesList.removeAtIndex(0)
                }
                tblVaccines.reloadData()
            }
            else
            {
                self.navigationController?.popViewControllerAnimated(true)
            }

        }
        
    }
    
    // MARK: PrepareForSegue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showVaccineSelectionView"
        {
            let vaccineSelectionVC = segue.destinationViewController as! VaccineSelectionTableViewController
            vaccineSelectionVC.selectedVaccine = sender as! String
        }
    }
}
