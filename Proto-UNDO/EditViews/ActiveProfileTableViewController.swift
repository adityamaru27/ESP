//
//  ActiveProfileTableViewController.swift
//  Proto-UNDO
//
//  Created by Tomasz on 10/24/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit
import Parse

class ActiveProfileTableViewController: UITableViewController {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var waitingView : UIView!
//    var children : [PFObject]! = nil
    var children : NSMutableArray!
    var acceptedChildren : NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.registerNib(UINib(nibName: "ActiveProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ActiveProfileCell")

        // WaitingView
        let waitingLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 25)) as UILabel!
        waitingLabel.text = "Getting Children ..."
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
        
        children = NSMutableArray()
        acceptedChildren = NSMutableArray()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        appDelegate.window?.addSubview(waitingView)
        
        let childQuery = PFQuery(className:"children")
        
        childQuery.whereKey("parent", equalTo: PFUser.currentUser()!)
        
        childQuery.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
//            self.waitingView.removeFromSuperview()
            
            if let error = error
            {
                let errorString = error.userInfo["error"] as! NSString
                UIAlertView(title: "", message: errorString as String, delegate: self, cancelButtonTitle: "Dismiss").show()
            }
            else
            {
                self.children.removeAllObjects()
                self.children.addObjectsFromArray(objects!)

                let shareQuery = PFQuery(className:"share")
                shareQuery.whereKey("invited_user", equalTo: PFUser.currentUser()!)
                shareQuery.includeKey("inviting_child")
                
                shareQuery.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                    self.waitingView.removeFromSuperview()
                    
//                    if let error = error
//                    {
//                        let errorString = error.userInfo["error"] as! NSString
//                        UIAlertView(title: "", message: errorString as String, delegate: self, cancelButtonTitle: "Dismiss").show()
//                    }
                    if error == nil
                    {
                        if objects != nil && objects?.count != 0
                        {
                            self.acceptedChildren.removeAllObjects()
                            if let objects = objects {
                                for shareObj in (objects)
                                {
                                    if shareObj["accepted"] != nil && shareObj["accepted"] as! Bool == true
                                    {
                                        self.acceptedChildren.addObject(shareObj);
                                    }
                                }
                            }
                            
                        }
                    }
                    self.tableView.reloadData()
                })
                
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if children != nil && children.count > 0
        {
            return children.count + acceptedChildren.count + 1
        }
        
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ActiveProfileTableViewCell! = tableView.dequeueReusableCellWithIdentifier("ActiveProfileCell") as! ActiveProfileTableViewCell
        
        cell.lblBottomSeparator.hidden = true
        cell.lblTopSeparator.hidden = true
        cell.lblTitle.hidden = false
        cell.backgroundColor = UIColor.whiteColor()
        cell.accessoryType = UITableViewCellAccessoryType.None
        
        if indexPath.row == 0 || indexPath.row == (children.count + acceptedChildren.count)
        {
            cell.lblBottomSeparator.hidden = false
        }
        
        if indexPath.row == 0
        {
            cell.lblTitle.hidden = true
            cell.backgroundColor = tableView.backgroundColor
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if indexPath.row > 0
        {
            var child : PFObject!
            if indexPath.row <= children.count
            {
                 child = children[indexPath.row - 1] as! PFObject
            }
            else
            {
                let shareObj = acceptedChildren.objectAtIndex(indexPath.row - children.count - 1)as! PFObject
                child = shareObj.objectForKey("inviting_child") as! PFObject
            }
            
            cell.lblTitle.text = (child["child_firstname"] as! String) + " " + (child["child_lastname"] as! String)
            
            if currentChild.objectId == child.objectId
            {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            
            
        }
        
        return cell!
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 35
        }
        
        return 45
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row > 0
        {
            if indexPath.row <= children.count
            {
                for child in children
                {
                    (child as! PFObject)["active"] = false
                    child.saveInBackgroundWithBlock(nil)
                }
                
                for shareObj in acceptedChildren
                {
                    (shareObj as! PFObject)["active"] = false
                    (shareObj as! PFObject).saveInBackgroundWithBlock(nil)
                }

                currentChild = children.objectAtIndex(indexPath.row - 1) as! PFObject
                currentChild["active"] = true
                currentChild.saveInBackgroundWithBlock(nil)
            }
            else
            {
                for child in children
                {
                    (child as! PFObject)["active"] = false
                    child.saveInBackgroundWithBlock(nil)
                }
                
                for shareObj in acceptedChildren
                {
                    (shareObj as! PFObject)["active"] = false
                    (shareObj as! PFObject).saveInBackgroundWithBlock(nil)
                }
                
                let shareObj = acceptedChildren.objectAtIndex(indexPath.row - children.count - 1) as! PFObject
                currentChild = shareObj["inviting_child"] as! PFObject
                shareObj["active"] = true
                shareObj.saveInBackgroundWithBlock(nil)
            }

            tableView.reloadData()
        }
    }
}


