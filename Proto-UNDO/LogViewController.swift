//
//  LogViewController.swift
//  Proto-UNDO
//
//  Created by Vlad Konon on 25.07.15.
//  Copyright (c) 2015 Curly Brackets. All rights reserved.
//

import UIKit
import Parse




class LogViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var topDividerHeightConstraint: NSLayoutConstraint!
    
    var btnLoadMore: UIButton!
    var mSelectedIndex: NSInteger!
    
    var isAnimating: Bool = false
    var dropDownViewIsDisplayed: Bool = false
    var controllerDropDownMenu :SortFilterViewController?
    
    let MostRecentFirst : Int = 0
    let Eat : Int = 5
    let Sleep : Int = 6
    let Poop : Int = 7
    let Medicine : Int = 8
    let Note : Int = 9
    
    
    let Last24hours : Int = 1
    let Last2days : Int = 2
    let Last1week : Int = 3
    let Olderthan1week : Int = 4
    
    
    let FilterOnPicture : Int = 0
    let FilterOnKey : Int = 1
    let FilterOnstar : Int = 2
    let FilterOnPerson : Int = 3
    let FilterOnExclamation : Int = 4
    let FilterOnStethoscope : Int = 5
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         btnLoadMore = UIButton(frame: CGRectMake(28, 15 , self.view.frame.width - 56, 57))
        btnLoadMore.hidden = true
        
        
        tableView.registerNib(UINib(nibName: "LogTableViewCell", bundle: nil), forCellReuseIdentifier: "logCell")
      
        updateEventsCount()
        //let attributes = [NSFontAttributeName : UIFont(descriptor: UIFontDescriptor(fontAttributes:  [UIFontDescriptorFaceAttribute: "Bold"]), size: 16)]
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(16)]
        //attributes
        self.navigationController!.navigationBar.barTintColor = UIColorFromRGB(0xF7F7F7)
        self.navigationController!.navigationBar.translucent = false
        
        NSLog("%@", self.navigationController!)
        
        
        self.controllerDropDownMenu  = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SortFilterViewController") as! SortFilterViewController
        
        //   self.controllerDropDownMenu = UIViewController(nibName: "SortFilterViewController", bundle: nil)
        
        self.controllerDropDownMenu!.view.frame = CGRectMake(0, -self.view.bounds.height, self.view.bounds.width, self.view.bounds.height)
        
        self.controllerDropDownMenu!.willMoveToParentViewController(self)
        self.view.addSubview(self.controllerDropDownMenu!.view)
        self.addChildViewController(self.controllerDropDownMenu!)
        self.controllerDropDownMenu!.didMoveToParentViewController(self)
        tableView.separatorColor = UIColor.whiteColor()
        
        
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func viewWillAppear(animated: Bool) {
   
        
        DataSource.sharedDataSouce.LastToday = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(LogViewController.dataChanged), name: kLogObjectAddedNotification, object: nil)
   
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(LogViewController.eventRemoved(_:)), name: kLogObjectRemovedNotification, object: nil)
        

        DataSource.sharedDataSouce.loadPageSize = 30
        
     if currentChild == nil
        {
            self.view.userInteractionEnabled = false
            self.navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "New Child Profile", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(LogViewController.showNewChildProfile(_:)))
            self.tableView.reloadData()
        }
        else
        {
            self.view.userInteractionEnabled = true
            DataSource.sharedDataSouce.reloadData()
            
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
            
            self.navigationItem.leftBarButtonItem =  UIBarButtonItem(title: child_fullname, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(LogViewController.onPressChild(_:)))
            
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.tabBarItem.setCustomBadgeValue(nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topDividerHeightConstraint.constant = 0.5
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showLogDetailViewController"
        {
            let controller = segue.destinationViewController as! LogDetailViewController
            controller.mSelectedIndex = self.mSelectedIndex
            NSLog("showLogDetailViewController");
            
        }
    }
    
    @objc func dataChanged(){
        tableView.reloadData()
        btnLoadMore.hidden = false
        
        tableView.tableFooterView = getFooterView()
        
        
    }
    @objc func eventRemoved(notification:NSNotification){
        let userInfo:Dictionary<String,Int!> = notification.userInfo as! Dictionary<String,Int!>
        let index:Int = userInfo["index"]!
        if index>=0 {
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Left)
        }
        tableView.userInteractionEnabled=true;
        activityIndicator.stopAnimating()
    }
    
    
    
    
    @IBAction func sortAction(sender: UIBarButtonItem) {
        
        
        if(!self.dropDownViewIsDisplayed)
        {
            
            UIView.animateWithDuration(0.8, delay: 0.4, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                
                self.controllerDropDownMenu?.view.frame = CGRectMake(0, 64.0, self.view.bounds.width,  self.view.bounds.height)
                
                
                }, completion: { (finished: Bool) -> Void in
                    
                    self.dropDownViewIsDisplayed = true
                    
                    
            })
        }
        else
        {
            UIView.animateWithDuration(0.8, delay: 0.4, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                
                self.controllerDropDownMenu?.view.frame = CGRectMake(0, -self.view.bounds.height, self.view.bounds.width,  self.view.bounds.height)
                
                
                }, completion: { (finished: Bool) -> Void in
                    
                    self.dropDownViewIsDisplayed = false
                    
                    if currentChild != nil
                    {
                        if (self.controllerDropDownMenu?.SortFilterCurrentStatus[self.MostRecentFirst]  != true)
                        {
                            DataSource.sharedDataSouce.sortOrder = .TimeAscending
                            sender.image = UIImage(named: "sort!")
                            
                        }
                        else
                        {
                            DataSource.sharedDataSouce.sortOrder = .TimeDescending
                            sender.image = UIImage(named: "sort")
                        }
                        
                        DataSource.sharedDataSouce.FilterOnEat = (self.controllerDropDownMenu?.SortFilterCurrentStatus[self.Eat])!
                        
                        DataSource.sharedDataSouce.FilterOnSleep = (self.controllerDropDownMenu?.SortFilterCurrentStatus[self.Sleep])!
                        
                        DataSource.sharedDataSouce.FilterOnPoop = (self.controllerDropDownMenu?.SortFilterCurrentStatus[self.Poop])!
                        
                        DataSource.sharedDataSouce.FilterOnMedicine = (self.controllerDropDownMenu?.SortFilterCurrentStatus[self.Medicine])!
                        
                        DataSource.sharedDataSouce.FilterOnNote = (self.controllerDropDownMenu?.SortFilterCurrentStatus[self.Note])!
                        
                        
                        DataSource.sharedDataSouce.Last24hours = (self.controllerDropDownMenu?.SortFilterCurrentStatus[self.Last24hours])!
                        
                        DataSource.sharedDataSouce.Last2days = (self.controllerDropDownMenu?.SortFilterCurrentStatus[self.Last2days])!
                        
                        DataSource.sharedDataSouce.Last1week = (self.controllerDropDownMenu?.SortFilterCurrentStatus[self.Last1week])!
                        
                        DataSource.sharedDataSouce.Olderthan1week = (self.controllerDropDownMenu?.SortFilterCurrentStatus[self.Olderthan1week])!
                        
                        
                        
                        DataSource.sharedDataSouce.FilterOnKey = (self.controllerDropDownMenu?.IconsFilterCurrentStatus[self.FilterOnKey])!
                        
                        DataSource.sharedDataSouce.FilterOnPerson = (self.controllerDropDownMenu?.IconsFilterCurrentStatus[self.FilterOnPerson])!
                        
                        
                        DataSource.sharedDataSouce.FilterOnStethoscope = (self.controllerDropDownMenu?.IconsFilterCurrentStatus[self.FilterOnStethoscope])!
                        
                        
                        DataSource.sharedDataSouce.FilterOnstar = (self.controllerDropDownMenu?.IconsFilterCurrentStatus[self.FilterOnstar])!
                        
                        
                        DataSource.sharedDataSouce.FilterOnExclamation = (self.controllerDropDownMenu?.IconsFilterCurrentStatus[self.FilterOnExclamation])!
                        
                        
                        DataSource.sharedDataSouce.FilterOnPicture = (self.controllerDropDownMenu?.IconsFilterCurrentStatus[self.FilterOnPicture])!
                        
                        
                        DataSource.sharedDataSouce.loadPageSize = 8
                        DataSource.sharedDataSouce.reloadData()
                    }
            })
        }
        
        
        /*
        
        if DataSource.sharedDataSouce.sortOrder == .TimeDescending {
        DataSource.sharedDataSouce.sortOrder = .TimeAscending
        sender.image = UIImage(named: "sort!")
        }
        else{
        DataSource.sharedDataSouce.sortOrder = .TimeDescending
        sender.image = UIImage(named: "sort")
        }
        DataSource.sharedDataSouce.reloadData()
        
        */
    }
    
    func updateEventsCount(){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            var count : Int = 0
            if currentChild != nil
            {
                count = DataSource.sharedDataSouce.count()
            }
            //            self.eventsLabel.text = "\(count) events"
            self.navigationItem.title = "(\(count)) Logs"
            if count==0 {
                self.overlayView.hidden=false
            }
            else{
                self.overlayView.hidden=true
            }
        })
    }
    
    //MARK: UITableView DataSource and Delegate Methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellID:String = "logCell"
        let cell: LogTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as! LogTableViewCell
        
        return cell
    }
    // staup cell only if displaying
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell2setup  = cell as! LogTableViewCell
        let event:LogEvent? = DataSource.sharedDataSouce.EventAtIndex(indexPath.row)
        if (event != nil){
            cell2setup.setupCell(event!)
            cell2setup.detailButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
            cell2setup.detailButton.addTarget(self, action: #selector(LogViewController.detailAction(_:)), forControlEvents: .TouchUpInside)
            cell2setup.detailButton.tag = indexPath.row
        }
        
        
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateEventsCount()
        if currentChild == nil
        {
            return 0
        }
        let count = DataSource.sharedDataSouce.count()
        print("HEYYY")
        print(count)
        return count
    }
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false;
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Delete"
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            DataSource.sharedDataSouce.deleteEventWithIndex(indexPath.row)
            tableView.userInteractionEnabled=false;
            activityIndicator.startAnimating()
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    func getFooterView() -> UIView
    {
        if DataSource.sharedDataSouce.canLoadMore(){
            // return more view
            let footer:UIView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 115))
            footer.backgroundColor = UIColor.clearColor()
            
            
            btnLoadMore.backgroundColor = UIColor(red: 3.0/255, green: 122.0/255, blue: 225.0/255, alpha: 1.0)
            btnLoadMore.setTitle("Load More", forState: UIControlState.Normal)
            btnLoadMore.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            btnLoadMore.titleLabel?.font = UIFont.systemFontOfSize(20)
            btnLoadMore.userInteractionEnabled = false
            
        
            
            btnLoadMore.clipsToBounds = true
            btnLoadMore.layer.cornerRadius = 13
            
            footer.addSubview(btnLoadMore)
            
            //            footer.backgroundColor = UIColor(white: 0.9, alpha: 0.2)
            //            let title:UILabel = UILabel(frame: footer.frame)
            //            title.text = "Show More ..."
            //            title.font = UIFont.systemFontOfSize(18)
            //            title.textColor = UIColor.blueColor()
            //            title.textAlignment = NSTextAlignment.Center
            //            footer.addSubview(title)
            let gr:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogViewController.loadMore(_:)))
            footer.addGestureRecognizer(gr)
            footer.userInteractionEnabled = true
            //            title.userInteractionEnabled=false
            return footer
        }
        return UIView(frame: CGRectZero)
    }
    
    /*
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if DataSource.sharedDataSouce.canLoadMore(){
            // return more view
            let footer:UIView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 115))
            footer.backgroundColor = UIColor.clearColor()
            
           
            btnLoadMore.backgroundColor = UIColor(red: 3.0/255, green: 122.0/255, blue: 225.0/255, alpha: 1.0)
            btnLoadMore.setTitle("Load More", forState: UIControlState.Normal)
            btnLoadMore.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            btnLoadMore.titleLabel?.font = UIFont.systemFontOfSize(20)
            btnLoadMore.userInteractionEnabled = false
            
            btnLoadMore.clipsToBounds = true
            btnLoadMore.layer.cornerRadius = 13
            
            footer.addSubview(btnLoadMore)
            
            //            footer.backgroundColor = UIColor(white: 0.9, alpha: 0.2)
            //            let title:UILabel = UILabel(frame: footer.frame)
            //            title.text = "Show More ..."
            //            title.font = UIFont.systemFontOfSize(18)
            //            title.textColor = UIColor.blueColor()
            //            title.textAlignment = NSTextAlignment.Center
            //            footer.addSubview(title)
            let gr:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "loadMore:")
            footer.addGestureRecognizer(gr)
            footer.userInteractionEnabled = true
            //            title.userInteractionEnabled=false
            return footer
        }
        return UIView(frame: CGRectZero)
    } */
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
    @objc func detailAction(sender:UIButton){
        showDetailForIndex(sender.tag)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated: false);
        showDetailForIndex(indexPath.row);
    }
    func showDetailForIndex(index:Int){
        mSelectedIndex = index
        self.navigationItem.title = "Logs"
        self.performSegueWithIdentifier("showLogDetailViewController", sender: self)
    }
    
    @objc func loadMore(sender:UIGestureRecognizer){
        let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        ai.color = UIColor.blackColor()
        sender.view?.addSubview(ai)
        let contentView = sender.view!
        ai.center = CGPointMake(contentView.frame.size.width*0.5, contentView.frame.size.height*0.5)
        ai.startAnimating()
        ai.tag=100
        DataSource.sharedDataSouce.loadData(5)
    }
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
    }
    
    @IBAction func onPressChild(sender: AnyObject) {
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
}

