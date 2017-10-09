//
//  ViewController.swift
//  ProtoUNDOTest
//
//  Created by Yury on 18/09/15.
//  Copyright © 2015 Yury. All rights reserved.
//

import UIKit
import Parse

@objc(ViewController) class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var viewGuide: UIView!
    var sections = NewDatasource.activeSections
    
    @IBOutlet weak var lblDummy: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableFooter: UIView!
    var undoView:UndoView = UndoView()
    
    var imgGuide : UIImageView!
    var tblTapGesture : UITapGestureRecognizer!
    
    var pumpCell : SliderTableViewCell!
    var bottleCell : SliderTableViewCell!
     var sleepCell : SleepTableViewCell!
    var keyboardFlag : Bool!
  
    
    // MARK:
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tabBarItem.title = "Home"
        tabBarItem.image = UIImage(named: "home")
        edgesForExtendedLayout = .Bottom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBAction func closeAction(sender: AnyObject) {
        
        viewGuide.removeFromSuperview()
    }
    
    @IBAction func createChildAction(sender: AnyObject) {
        
          viewGuide.removeFromSuperview()
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let childVC = storyboard.instantiateViewControllerWithIdentifier("NewChildProfileView") as! NewChildProfileViewController
        childVC.isNewMoreChild = false
        let navVC = UINavigationController(rootViewController: childVC)
        
        self.presentViewController(navVC, animated: true, completion: nil)
        
        
    }
    @IBAction func acceptChildAction(sender: AnyObject) {
        
          viewGuide.removeFromSuperview()
        
        let shareProfileVC = UIStoryboard(name: "Collaborate", bundle: nil).instantiateViewControllerWithIdentifier("ManageInvitesNavView")
        self.presentViewController(shareProfileVC, animated: true, completion: nil)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.dismissSelf), name: "Child_Removed_Notification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.noteObjectAddedAction), name: kNoteObjectAddedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.exclamationMarkAddedActin), name: kExclamationMarkAddedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.noteExclamationMarkAddedAction), name: kNoteExclamationMarkAddedNotification, object: nil)
        
        tableView.registerNib(UINib(nibName: "SliderTableViewCell", bundle: nil), forCellReuseIdentifier: "CellSlider")
         tableView.registerNib(UINib(nibName: "SleepTableViewCell", bundle: nil), forCellReuseIdentifier: "CellSliderSleep")
        tableView.registerNib(UINib(nibName: "ActionsTableViewCell", bundle: nil), forCellReuseIdentifier: "CellActions")
        tableView.registerNib(UINib(nibName: "MemoTableViewCell", bundle: nil), forCellReuseIdentifier: "CellMemo")
        
        tableFooter.frame = CGRectMake(0, 0, self.view.bounds.width, 80)
        tableView.tableFooterView = tableFooter

        undoView.hidden = true
        view.addSubview(undoView)
        
     /*   imgGuide = UIImageView(image: UIImage(named: "guide"))
        imgGuide.frame = UIScreen.mainScreen().bounds
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("onHideGuide"))
        imgGuide.userInteractionEnabled = true
        imgGuide.addGestureRecognizer(tapGesture)
       */
        
        if currentChild == nil
        {
          //  self.tabBarController?.view .addSubview(imgGuide)
          //  viewGuide.frame  = UIScreen.mainScreen().bounds
            
            
            
            self.tabBarController?.view .addSubview(viewGuide)
            
           
            
            
            
        }
        
        
        
        tblTapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.onShowGuide))
    }
    
    override func viewDidLayoutSubviews() {
        
        let selfSize = view.bounds.size
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        
        undoView.frame = CGRectMake(0, selfSize.height - tabBarHeight - 75, selfSize.width, 75)

        
        
        
        var width = (selfSize.width / 100) * 55
        width = width - undoView.lblDuration.frame.origin.x
        undoView.durationWidth.constant = width
        undoView.lblDuration.superview?.updateConstraints()
        
        undoView.updateConstraints()
        undoView.layoutIfNeeded()
      
        
        let lineView = UIView(frame: CGRectMake(0, 0, selfSize.width, 1))
        lineView.backgroundColor = UIColor(red:228.0/255.0, green:227.0/255.0, blue:229.0/255.0, alpha:1.0)
        undoView.addSubview(lineView)
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController!.navigationBarHidden = false
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1)

        if currentChild == nil
        {
            self.tableView.addGestureRecognizer(tblTapGesture);
            self.navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "New Child Profile", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.showNewChildProfile(_:)))
            self.tableView.reloadData()
        }
        else
        {
            self.tableView.removeGestureRecognizer(tblTapGesture)
            
            let firstname = currentChild["child_firstname"] as? String
            let lastname = currentChild["child_lastname"] as? String
            
            var child_fullname : String = firstname!
            if firstname != ""
            {
                child_fullname += " "
            }
            if lastname != ""
            {
                child_fullname += lastname!.substringToIndex(lastname!.startIndex.successor())
                child_fullname += "."
            }
            
            self.navigationItem.leftBarButtonItem =  UIBarButtonItem(title: child_fullname, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.showChildView(_:)))
            self.tableView.reloadData()
        }
        
        let button: UIButton = UIButton(type: UIButtonType.Custom)
      //  button.setImage(UIImage(named: "cust_btn"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(ViewController.showCustomizeView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        button.frame = CGRectMake(0, 0, 100, 25)
        
        let label: UILabel = UILabel(frame: CGRectMake(8, 0, 100, 25))
        label.font = UIFont(name: "SU UI Text", size: 13)
        label.text = "Customize"
        label.textAlignment = NSTextAlignment.Right
       // label.textColor = UIColor.blueColor()
        label.textColor=UIColor(red:0.0, green: 122.0/255.0, blue:1.0, alpha: 1.0)
//        label.backgroundColor = UIColor.clearColor()
        button.addSubview(label)
        
        let barButton: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
      
        
        if ( pumpCell != nil )
        {
            if ((NSUserDefaults.standardUserDefaults().objectForKey("Measurements")?.isEqualToString("oz")) == true) {
                pumpCell.valueLabel.text = "oz"
            }
            else
            {
                pumpCell.valueLabel.text = "mL"
            }
        }
        
        if ( bottleCell != nil )
        {
            if ((NSUserDefaults.standardUserDefaults().objectForKey("Measurements")?.isEqualToString("oz")) == true) {
                bottleCell.valueLabel.text = "oz"
            }
            else
            {
                bottleCell.valueLabel.text = "mL"
            }
        }

    }
    
    func showCustomizeView(sender: AnyObject?){
    /*   let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("showCustomize")
        vc.modalTransitionStyle = .CrossDissolve
        presentViewController(vc, animated: true, completion: nil)
        */
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Story", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("CustomizMenu")
       // vc.modalTransitionStyle = .CrossDissolve
        //presentViewController(vc, animated: true, completion: nil)
        
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func dismissSelf()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func showChildView(sender :  AnyObject?)
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Child", bundle: nil)
        let childDetailVC = storyboard.instantiateViewControllerWithIdentifier("ChildDetailNavView")
        
        self.presentViewController(childDetailVC, animated: true, completion: nil)
        
    }
    
    func showNewChildProfile(sender : AnyObject?)
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let childVC = storyboard.instantiateViewControllerWithIdentifier("NewChildProfileView") as! NewChildProfileViewController
        childVC.isNewMoreChild = false
        let navVC = UINavigationController(rootViewController: childVC)
        
        self.presentViewController(navVC, animated: true, completion: nil)
    }
    
    
    
     func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        
        if ( textField.tag == 101)
        {
            let stringValue : String = textField.text!
            let length : Int = stringValue.characters.count
            var ShouldReplace : Bool
            ShouldReplace = true
            
            if (!string.isEmpty)
            {
                if ( length == 2 )
                {
                    textField.text = stringValue.stringByAppendingString(":")
                }
                else if ( length > 4)
                {
                    ShouldReplace = false
                }
                
            }
            
            return ShouldReplace
            
        }
        return true
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
       let point: CGPoint = textField.convertPoint(textField.frame.origin, toView: self.view)
        
        if (point.y <= 280)
        {
            keyboardFlag = false
            return
        }
        
        keyboardFlag = true

        if (textField.tag == 101)
        {
            
            animateViewMoving(true, moveValue: 200)
            
            
            let datePickerView:UIDatePicker = UIDatePicker()
            
            datePickerView.locale = NSLocale.init(localeIdentifier :  "en_GB")
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat =  "HH:mm"
            
            let date = dateFormatter.dateFromString("00:00")
            
            datePickerView.date = date!
                
            datePickerView.datePickerMode = UIDatePickerMode.Time
            
            textField.inputView = datePickerView
            
            datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        }
        else
        {
            animateViewMoving(true, moveValue: 100)
        }
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
       
        dateFormatter.dateFormat = "HH:mm"
        
        sleepCell.txtQty.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if (keyboardFlag == false)
        {
            return
        }
        
        if (textField.tag == 101)
        {
             animateViewMoving(false, moveValue: 200)
        }
        else
        {
        
        animateViewMoving(false, moveValue: 100)
        }
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    
    func reloadData() {
        sections = NewDatasource.activeSections
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count + 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sections.count {
            return sections[section].items.count
        }
        return 0
    }
    
   /* func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < sections.count {
            return sections[section].name
        }
        return " "
    }*/
    
    
    
     func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerFrame = tableView.frame
        
        let headerView:UIView = UIView(frame: CGRectMake(0, 0, headerFrame.size.width,44.0))
        
        if section < sections.count {
        let item = sections[section].items[0]
        
        
        headerView.backgroundColor = LogEvent(item: item, _action:0).getprimaryColor()
        
        if section < sections.count {
        let title = UILabel()
        title.frame = CGRectMake(15, 0, 150, 44.0)
            
        title.font = UIFont(name: "SFUIDisplay-Semibold", size: 20)

        title.text = sections[section].name as? String
        title.textColor = LogEvent(item: item, _action:0).getHeadLineTextColor()
        title.backgroundColor = UIColor.clearColor()
            

        headerView.addSubview(title)
        
          if title.text == "Medicine"
          {
        let headBttn:UIButton = UIButton(type: UIButtonType.DetailDisclosure) as UIButton
       
        headBttn.frame = CGRectMake(100, 0, 44, 44)
           
        headBttn.enabled = true
        headBttn.tintColor = UIColor.whiteColor()
         
        headBttn.addTarget(self, action: #selector(ViewController.buttonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        headerView.addSubview(headBttn)
            }
        }
        
        
        
        }
        return headerView
        
    }
    
    func buttonAction(sender:UIButton!)
    {
         
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("renamePopover") as! CustomActionsViewController
        vc.type = "medicine"
        self.presentViewController(vc, animated: true, completion: nil)
       

    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == sections.count {
            return 30
        } else {
            
            let item = sections[indexPath.section].items[indexPath.row]
            
            if let slider = item as? SliderEventItem {
      
                if ( item.type == "sleep" ){
                    
                    return 137
                }
            }
            return sections[indexPath.section].type == "note" ? 45 : 95
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        
        if let slider = item as? SliderEventItem {
            
           
            
             if ( item.type == "sleep" )
             {
               let cell = tableView.dequeueReusableCellWithIdentifier("CellSliderSleep") as! SleepTableViewCell
               
                cell.item = slider
                
                cell.txtQty.delegate = self
                cell.txtQty.tag = 101
                
                sleepCell = cell
                
                if currentChild == nil
                {
                    cell.userInteractionEnabled = false
                }
                else
                {
                    cell.userInteractionEnabled = true
                }
                return cell

            }
           
            
            let cell = tableView.dequeueReusableCellWithIdentifier("CellSlider") as! SliderTableViewCell
            
            
            cell.item = slider
            if ( item.type == "pump" ){
            cell.txtQty.delegate = self
            pumpCell = cell
                
            }
            else if item.type == "bottle"
            {
                bottleCell = cell
                
            }
            if currentChild == nil
            {
                cell.userInteractionEnabled = false
            }
            else
            {
                cell.userInteractionEnabled = true
            }
            return cell
        }
        else if item.type == "note" {
            let cell = tableView.dequeueReusableCellWithIdentifier("CellMemo") as! MemoTableViewCell
            cell.item = item
            if currentChild == nil
            {
                cell.userInteractionEnabled = false
            }
            else
            {
                cell.userInteractionEnabled = true
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CellActions") as! ActionsTableViewCell
            cell.item = item
        
            cell.reDrawView()
            
            if currentChild == nil
            {
                cell.userInteractionEnabled = false
            }
            else
            {
                cell.userInteractionEnabled = true
            }
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            cell.setNeedsDisplay()
            
            return cell
        }
    }
    
    // MARK: - Actions
    func onAccessoryButtonTapped(item: EventItem) {
        let segueName: String
        
        if item.type == "medicine" {
            segueName = "showMedicine"
        } else if item.type == "note" {
            segueName = "showNote"
        } else if item.type == "poop" {
            segueName = "showPoop"
        } else if item.type == "pee" {
            segueName = "showPee"
        } else if item.type == "breast" {
            segueName = "showBreast"
        } else if item.type == "sleep" {
            segueName = "sleepMore"
        }
        else if item.type == "pump" {
            segueName = "showPumpMore"
        }
        else if item.type == "bottle" {
            segueName = "showBottleMore"
        }
        else if item is SliderEventItem {
            segueName = "showValued"
        }
        else {
            segueName = ""
            print("Incorrect item type!!!")
        }
        showDetailsForItem(item, segueName: segueName)
    }
    
    func showDetailsForItem(item: EventItem, segueName: String) {
        if segueName == "showMedicine" {
            //medicineMore
          /*  let storyboard : UIStoryboard = UIStoryboard(name: "MoreViewController", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! MoreViewController
            vc.item = item
            navigationController?.pushViewController(vc, animated: true)
            return
            */
           // medicineMoreVC
        /*  let storyboard : UIStoryboard = UIStoryboard(name: "sleep", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("medicineMore") as! MedicineMoreViewController
            
            vc.logEvent = LogEvent(customItem: item)
            navigationController?.pushViewController(vc, animated: true)
            
            */
            
            
            let storyboard : UIStoryboard = UIStoryboard(name: "sleep", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("medicineMoreVC") as! MedicineMoreVC
            
            
            vc.hidesBottomBarWhenPushed = true
            vc.logEvent = LogEvent(customItem: item)
            navigationController?.pushViewController(vc, animated: true)
            
            
            return

        }
        else if segueName == "showNote" {
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier(segueName) as! NoteMoreTableViewController
            
            vc.logEvent = LogEvent(customItem: item)
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        else if segueName == "showPoop" {
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier(segueName) as! PoopMoreTableViewController
             vc.hidesBottomBarWhenPushed = true
            vc.logEvent = LogEvent(customItem: item)
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        else if segueName == "showPee" {
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier(segueName) as! PeeMoreTableViewController
             vc.hidesBottomBarWhenPushed = true
            vc.logEvent = LogEvent(customItem: item)
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        else if segueName == "showBreast" {
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier(segueName) as! BothMoreTableViewController
            
             vc.hidesBottomBarWhenPushed = true
          /*  if item.actions[0].name == "Left" {
                vc.optAction = BothMoreSettingData.BreastActions.ActLeft
            }
            else if item.actions[0].name == "Right" {
                vc.optAction = BothMoreSettingData.BreastActions.ActRight
            }
            else {*/
                vc.optAction = BothMoreSettingData.BreastActions.ActBoth
           // }
            
            vc.logEvent = LogEvent(customItem: item)
            
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        else if segueName == "showPumpMore"
        {
            let storyboard : UIStoryboard = UIStoryboard(name: "sleep", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier(segueName) as! PumpMoreVC
            
             vc.hidesBottomBarWhenPushed = true
           
             vc.optAction = PumpMoreSettingData.PumpActions.ActBoth
            
            
            vc.logEvent = LogEvent(customItem: item)
            
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        else if segueName == "showBottleMore"
        {
            let storyboard : UIStoryboard = UIStoryboard(name: "sleep", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier(segueName) as! BottleMoreVC
             vc.hidesBottomBarWhenPushed = true
            vc.logEvent = LogEvent(customItem: item)
            
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        else if segueName == "sleepMore" {
        
            
            let storyboard : UIStoryboard = UIStoryboard(name: "sleep", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier(segueName) as! SleepTableViewController
             vc.hidesBottomBarWhenPushed = true
             vc.logEvent = LogEvent(customItem: item)
            navigationController?.pushViewController(vc, animated: true)
            return

        }
        
        
        
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier(segueName) as! EventDetailViewController
         vc.hidesBottomBarWhenPushed = true
        vc.event = LogEvent(customItem: item)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func customizeTapped() {
        /*let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("showCustomize")
        vc.modalTransitionStyle = .CrossDissolve
        presentViewController(vc, animated: true, completion: nil)*/
    }
    
    var memoInput:MemoInputViewController? = nil
    func showInput(cell: MemoTableViewCell, isPhotoTapped: Bool) {
        memoInput?.view.removeFromSuperview()
        memoInput  = MemoInputViewController(nibName: "MemoInputViewController", bundle: nil);
        memoInput!.loadView()
        memoInput!.viewDidLoad()
        
        let window:UIWindow = UIApplication.sharedApplication().windows.first!
        var frame:CGRect = cell.frame
        
        frame.size.height = memoInput!.view.frame.size.height
        frame =  CGRectOffset(frame, -tableView.contentOffset.x, -tableView.contentOffset.y);
        frame =  CGRectOffset(frame, tableView.frame.origin.x, tableView.frame.origin.y + 13);
        memoInput!.view.frame = frame
        //let window:UIWindow = UIApplication.sharedApplication().windows.first!
        //        let rootVC = UIApplication.sharedApplication().keyWindow!.rootViewController!
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // backgound view
        let bgView = UIView(frame: (appDelegate.window?.bounds)!);
        bgView.backgroundColor = UIColor(white: 0.0, alpha: 0.5);
        let gr = UITapGestureRecognizer(target: memoInput!, action: "cancelAction:")
        bgView.addGestureRecognizer(gr)
        appDelegate.window?.addSubview(bgView)
        appDelegate.window?.addSubview(memoInput!.view)
        
        if isPhotoTapped {
            memoInput!.photoAction(cell)
        } else {
            memoInput!.textField.becomeFirstResponder()
        }
        memoInput!.backgroundView = bgView
        
        bgView.alpha = 0;
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            bgView.alpha = 0.5
        })
        
    }
    
    func noteObjectAddedAction()
    {
        let text = (PFUser.currentUser()!["full_name"] as! String) + " has added a Note to the profile of " + (currentChild!["child_firstname"] as! String) + " " + (currentChild!["child_lastname"] as! String)
        sendPushNotification(text)
    }
    
    func exclamationMarkAddedActin()
    {
        let text = (PFUser.currentUser()!["full_name"] as! String) + " has Marked as urgent to the profile of " + (currentChild!["child_firstname"] as! String) + " " + (currentChild!["child_lastname"] as! String)
        sendPushNotification(text)
    }
    
    func noteExclamationMarkAddedAction()
    {
        let text = (PFUser.currentUser()!["full_name"] as! String) + " has added a Note and Marked it as urgent to the profile of " + (currentChild!["child_firstname"] as! String) + " " + (currentChild!["child_lastname"] as! String)
        sendPushNotification(text)
    }
    
    func sendPushNotification(text : String)
    {
        if (currentChild!["parent"] as! PFUser).objectId == PFUser.currentUser()?.objectId
        {
            let shareQuery = PFQuery(className:"share")
            shareQuery.whereKey("inviting_child", equalTo: currentChild!)
            shareQuery.includeKey("invited_user")
            
            shareQuery.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil
                {
                    if objects != nil && objects?.count != 0
                    {
                        let invitedActiveUsers : NSMutableArray = NSMutableArray()
                        
                        if let objects = objects{
                            for shareObj in (objects)
                            {
                                if shareObj["accepted"] != nil && shareObj["accepted"] as! Bool == true && shareObj["active"] as! Bool == true
                                {
                                    invitedActiveUsers.addObject(shareObj["invited_user"] as! PFUser)
                                }
                            }
                        }
                        
                        
                        if invitedActiveUsers.count > 0
                        {
                            let pushQuery = PFInstallation.query()
                            for userObj in invitedActiveUsers
                            {
                                pushQuery!.whereKey("user", equalTo: userObj as! PFUser)
                            }
                            
                            let push = PFPush()
                            push.setQuery(pushQuery)
                            push.setMessage(text)
                            push.sendPushInBackgroundWithBlock(nil)
                        }
                    }
                }
            })
        }
        else
        {
            let pushQuery = PFInstallation.query()
            pushQuery!.whereKey("user", equalTo: currentChild!["parent"] as! PFUser)
            
            let push = PFPush()
            push.setQuery(pushQuery)
            push.setMessage(text)
            push.sendPushInBackgroundWithBlock(nil)
        }
    }
    
    
    
    func onShowGuide()
    {
        self.tabBarController?.view .addSubview(viewGuide)
    }
    
}
