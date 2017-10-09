//
//  SelectViewController.swift
//  Proto-UNDO
//
//  Created by Vlad Konon on 13.08.15.
//  Copyright (c) 2015 Curly Brackets. All rights reserved.
//

import UIKit

class CustomizeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sections = NewDatasource.getAllDatasource()
   
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightOfTable: NSLayoutConstraint!
    var prevState:[Bool] = []
    var changed:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0 ..< DataSource.sharedDataSouce.allEvents.count {
            prevState.append(DataSource.sharedDataSouce.isEventIndexActive(i))
        }
        /*var tableHeight:CGFloat =  44 * CGFloat( DataSource.sharedDataSouce.allEvents.count)
        if (tableHeight > self.view.frame.size.height){
        tableHeight = self.view.frame.size.height
        }
        else {
        tableView.scrollEnabled = false
        }
        heightOfTable.constant = tableHeight
        saveButton.enabled = false*/
        
        saveButton.tintColor = UIColor.clearColor()
        saveButton.enabled = false
        
        cancelButton.title = "Dismiss"
        
        tableView.scrollEnabled = false
        
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraints()
        
        //        var saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveAction:")
        //        navigationItem.rightBarButtonItem = saveButton
        //
        //        var backButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "back:")
        //        navigationItem.leftBarButtonItem = backButton
        
        checkDeviceType()
        
        let color = UIColor(hexString: "#1E1831")
        let semicolor = color!.colorWithAlphaComponent(0.3)
        self.view.backgroundColor = semicolor
        tableView.backgroundColor = UIColor.clearColor()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //let window:UIWindow = UIApplication.sharedApplication().keyWindow!
        //self.backgroundImage.image = window.getBlur()
        tableView.reloadData()
    }
    @IBAction func saveAction(sender: AnyObject) {
        
        NSLog("save");
        DataSource.sharedDataSouce.updateActiveEvents()
        self.back(sender)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName(kEventsListChangedNotification, object: nil)
        })
    }
    @IBAction func back(sender: AnyObject) {
        if !changed {
            
            for i in 0 ..< DataSource.sharedDataSouce.allEvents.count {
                DataSource.sharedDataSouce.setEventWithIndexActive(i, active: prevState[i])
            }
            DataSource.sharedDataSouce.updateActiveEvents()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else{
            self.dismissViewControllerAnimated(true, completion: nil)
            /*
            let confirm = UIActionSheet(title: "Are you sure to \"Cancel\"?\nThe event will be deleted", delegate: self, cancelButtonTitle: "No, don't delete", destructiveButtonTitle: "Yes, cancel and delete")
            confirm.tag = 100
            confirm.showInView(self.view)
            */
            //confirm.showFromBarButtonItem(navigationItem.leftBarButtonItem, animated: true)
            
          
            DataSource.sharedDataSouce.updateActiveEvents()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(kEventsListChangedNotification, object: nil)
                })
            
        }
    }
    var titleForCustomize:String? = nil
    @IBAction func renameAction(sender: UIButton) {
        titleForCustomize = sender.titleForState(UIControlState.Disabled)
        self.performSegueWithIdentifier("renamePopover", sender: self)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "renamePopover"){
            let controller:CustomActionsViewController = segue.destinationViewController as! CustomActionsViewController
            controller.type = titleForCustomize!
        }
    }
    
    //MARK: table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSource.sharedDataSouce.allEvents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("selectCell")!
        let button:UIButton = cell.contentView.viewWithTag(1) as! UIButton
        let title:String = DataSource.sharedDataSouce.allEvents[indexPath.row]
        let btnCheck:MyCheckBox = cell.contentView.viewWithTag(8) as! MyCheckBox
        let viewDevider = cell.contentView.viewWithTag(4)

        button.setTitle(title.capitalizedString, forState: UIControlState.Normal)
        button.selected = DataSource.sharedDataSouce.isEventIndexActive(indexPath.row)
        btnCheck.isChecked = DataSource.sharedDataSouce.isEventIndexActive(indexPath.row)
        
          
        let renameButton:UIButton = cell.contentView.viewWithTag(2) as! UIButton
        
        let eventDict:NSDictionary! = kEvents[title] as! NSDictionary
        
        if (indexPath.row != DataSource.sharedDataSouce.allEvents.count - 1) {
            
                let separator = UIView(frame: CGRect(x: 0, y: 45, width: self.view.bounds.size.width, height: 5))
            let color = UIColor(hexString: "#1E1831")
            let semicolor = color!.colorWithAlphaComponent(0.3)
                separator.backgroundColor = UIColor.clearColor()
                cell.addSubview(separator)
            
        } else {
        }
        
      
            viewDevider?.hidden = true
        

            renameButton.hidden = true
        
        if (deviceType == "4") {
            button.imageEdgeInsets.left = 275
        } else if (deviceType == "6") {
            button.imageEdgeInsets.left = 330
        } else if (deviceType == "6+") {
            button.imageEdgeInsets.left = 370
        }
        
        if indexPath.row < sections.count {
            let item = sections[indexPath.row].items[0]
            
            button.backgroundColor = LogEvent(item: item, _action:0).getprimaryColor()
            button.setTitleColor(LogEvent(item: item, _action:0).getHeadLineTextColor(), forState: UIControlState.Normal)
            button.setTitleColor(LogEvent(item: item, _action:0).getHeadLineTextColor(), forState: UIControlState.Selected)
            cell.backgroundColor = UIColor.clearColor()
            cell.contentView.backgroundColor = UIColor.clearColor()
            
            let lineView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 1))
            lineView.backgroundColor=UIColor.lightGrayColor()
            button.addSubview(lineView)
            
            let lineView1 = UIView(frame: CGRectMake(0, button.frame.size.height - 1, tableView.frame.size.width, 1))
            lineView1.backgroundColor=UIColor.lightGrayColor()
            button.addSubview(lineView1)
            
        }
        
        
        return cell
    }
    
    func UIColorFromRGBA(colorCode: String, alpha: Float = 1.0) -> UIColor {
        let scanner = NSScanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        changed = true
        // saveButton.enabled = true
//        cancelButton?.tintColor = UIColor.redColor()
        let value = !DataSource.sharedDataSouce.isEventIndexActive(indexPath.row)
        DataSource.sharedDataSouce.setEventWithIndexActive(indexPath.row, active: value)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
        return indexPath
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height:CGFloat! = 0
        if (indexPath.row == 6) {
            height = 50.0
        } else {
            height = 50.0
        }
        if (indexPath.row == DataSource.sharedDataSouce.allEvents.count - 1) {
            height = height - 5.0
        }
        return height;
    }
    
    var deviceType : String = ""
    func checkDeviceType() {
        if UIScreen.mainScreen().bounds.size.width == 320  {
            deviceType = "4"
        } else if UIScreen.mainScreen().bounds.size.width == 375 {
            deviceType = "6"
        } else if UIScreen.mainScreen().bounds.size.width == 414 {
            deviceType = "6+"
        } else if UIScreen.mainScreen().bounds.size.width == 768 {
            deviceType = "IPAD"
        }
    }
}
