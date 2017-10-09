//
//  ManageInvitesTableViewController.swift
//  Proto-UNDO
//
//  Created by Tomasz on 10/29/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit
import Parse

class ManageInvitesTableViewController: UITableViewController {

    @IBOutlet weak var lblNoDataMsg: UILabel!
//    var isSwitchToAcceptedProfile : Bool? = true
    
    var invitingUserList : NSMutableArray!
    
    // Activity Indicator
    var waitingView : UIView!
    var waitingLabel : UILabel!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // WaitingView for Create Acccount
        waitingLabel = UILabel(frame: CGRectZero)
        waitingLabel.text = "Getting Inviting Users"
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
        
        invitingUserList = nil
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
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
      lblNoDataMsg.hidden = true
            
        if invitingUserList == nil
        {
            invitingUserList = NSMutableArray()
        }
        else
        {
            for shareObj in invitingUserList
            {
                let childObj = (shareObj as! PFObject)["inviting_child"]
                if currentChild.objectId != childObj?.objectId
                {
                    (shareObj as! PFObject)["active"] = false
                    shareObj.saveInBackgroundWithBlock(nil)
                }
                else
                {
                    (shareObj as! PFObject)["active"] = true
                    shareObj.saveInBackgroundWithBlock(nil)
                }
            }
            
            self.tableView.reloadData()
            return
        }
        
        waitingLabel.hidden = true
        self.appDelegate.window?.addSubview(self.waitingView)
        
        let shareQuery = PFQuery(className:"share")
        shareQuery.whereKey("invited_user", equalTo: PFUser.currentUser()!)
        shareQuery.includeKey("inviting_child")
        
        shareQuery.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            self.waitingView.removeFromSuperview()
            
            if let error = error
            {
                let errorString = error.userInfo["error"] as! NSString
                UIAlertView(title: "", message: errorString as String, delegate: self, cancelButtonTitle: "Dismiss").show()
            }
            else
            {
                if objects != nil && objects?.count != 0
                {
                    self.invitingUserList.removeAllObjects()
                    self.invitingUserList.addObjectsFromArray(objects!)
                    
                    self.lblNoDataMsg.hidden = true
                    
                    self.tableView.reloadData()
                }
                else
                {
                    self.lblNoDataMsg.hidden = false
                    if NSUserDefaults.standardUserDefaults().boolForKey("IS_VALID_USER") == false
                    {
                        if isTrailPeriod()
                        {

                    self.getProMessagePopup()
                        }
                    }
                }
            }
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
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
        return 1 + invitingUserList.count;
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        switch (indexPath.row)
        {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("SeparatorCell")
            
        default:
            let manageInviteCell = tableView.dequeueReusableCellWithIdentifier("ManageInviteCell") as! ManageInviteCell
            
            let shareObj = invitingUserList.objectAtIndex(indexPath.row - 1) as! PFObject
            let childObj = shareObj["inviting_child"] as! PFObject
            
            let firstname = childObj["child_firstname"] as? String
            let lastname = childObj["child_lastname"] as? String
            
            manageInviteCell.lblChildName.text = firstname! + " " + lastname!
            
            let accepted = shareObj["accepted"] as? Bool
            
            if accepted == nil
            {
                manageInviteCell.lblInviteStatus.text = "Pending"
                manageInviteCell.lblInviteStatus.textColor = UIColor.lightGrayColor()
            }
            else if accepted == true
            {
                manageInviteCell.lblInviteStatus.text = "Accepted"
                manageInviteCell.lblInviteStatus.textColor = UIColor.blackColor()
            }
            else if accepted == false
            {
                manageInviteCell.lblInviteStatus.text = "Decline"
                manageInviteCell.lblInviteStatus.textColor = UIColor.blackColor()
            }
            
            return manageInviteCell
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.row)
        {
        case 0:
            return 20
        default:
            return 55
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row >= 1
        {
            let shareObj = invitingUserList.objectAtIndex(indexPath.row - 1) as! PFObject
          
            let accepted = shareObj["accepted"] as? Bool
            
            if accepted == nil
            {
                if NSUserDefaults.standardUserDefaults().boolForKey("IS_VALID_USER") == false
                {
                    if isTrailPeriod()
                    {

                    self.getProMessagePopup()
                        return
                    }
                    
                    
                }

            }
            
            self.performSegueWithIdentifier("InviteDetailSegue", sender: indexPath.row - 1)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "InviteDetailSegue"
        {
            let inviteDetailVC = segue.destinationViewController as! InviteDetailTableViewController
            let index = sender as! Int
            inviteDetailVC.shareObject = invitingUserList.objectAtIndex(index) as! PFObject
        }
    }
    
    @IBAction func onPressDismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
