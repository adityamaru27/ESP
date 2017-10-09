//
//  ShareProfileTableViewController.swift
//  Proto-UNDO
//
//  Created by Tomasz on 10/28/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit
import Parse

class ShareProfileTableViewController: UITableViewController {
    
    var isFirstLoad : Bool! = false
    var isEmailExist : Bool!
    var isEmailValidation : Bool!
    var isEmailEmpty : Bool!
    var invitedUserList : NSMutableArray!
    
    // Activity Indicator
    var waitingView : UIView!
    var waitingLabel : UILabel!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()

        isEmailExist = true
        isEmailValidation = true
        isEmailEmpty = false
        
        // WaitingView for Create Acccount
        waitingLabel = UILabel(frame: CGRectZero)
        waitingLabel.text = "Inviting"
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
        
        invitedUserList = NSMutableArray()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        waitingLabel.hidden = true
        self.appDelegate.window?.addSubview(self.waitingView)
        
        let shareQuery = PFQuery(className:"share")
        shareQuery.whereKey("inviting_child", equalTo: currentChild!)
        
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
                    self.invitedUserList.removeAllObjects()
                    self.invitedUserList.addObjectsFromArray(objects!)
                }
            }
            
            self.isFirstLoad = true
            self.tableView.reloadData()
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
        return 5 + invitedUserList.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.row)
        {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("TopSeparatorCell")
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("ShareProfileDetailTableViewCell") as! ShareProfileDetailTableViewCell
            let firstname = currentChild["child_firstname"] as? String
            let lastname = currentChild["child_lastname"] as? String
            let childDOB = currentChild["child_dob"] as? String
            
            cell.lblChildName.text = firstname! + " " + lastname!
            cell.lblChildDOB.text = childDOB!
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("InputEmailDescriptionCell")
            return cell!
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("InviteEmailInputTableViewCell") as! InviteEmailInputTableViewCell
            cell.inviteButtonPressed = { (isEmailValidation : Bool) in
                
                if cell.txtEmail.text == ""
                {
                    self.isEmailEmpty = true
                    self.isEmailExist = true
                    self.isEmailValidation = true
                    self.tableView.reloadData()
                    return
                }
                
                self.isEmailEmpty = false
                self.isEmailValidation = isEmailValidation
                if isEmailValidation == false
                {
                    self.isEmailExist = true
                    self.tableView.reloadData()
                    return
                }
                
                self.waitingLabel.hidden = false
                self.appDelegate.window?.addSubview(self.waitingView)
                
                let shareQuery = PFQuery(className:"share")
                shareQuery.whereKey("inviting_child", equalTo: currentChild!)
                shareQuery.whereKey("invited_user_email", matchesRegex: cell.txtEmail.text!, modifiers: "i")
                shareQuery.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                    if let error = error {
                        self.waitingView.removeFromSuperview()
                        
                        let errorString = error.userInfo["error"] as! NSString
                        self.showMessage("Sharing Failed.", message: errorString as String)
                    }
                    else
                    {
                        if objects != nil && objects?.count > 0
                        {
                            self.isEmailExist = true
                            self.waitingView.removeFromSuperview()
                            self.showMessage("", message: "This User was invited already.")
                            self.tableView.reloadData()
                            return
                        }
                        else
                        {
                            let query = PFUser.query() as PFQuery!
                            query.whereKey("email", matchesRegex: cell.txtEmail.text!, modifiers: "i")
                            
                            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                                
                                if let error = error {
                                    self.waitingView.removeFromSuperview()
                                    
                                    let errorString = error.userInfo["error"] as! NSString
                                    self.showMessage("Sharing Failed.", message: errorString as String)
                                    
                                    // Show the errorString somewhere and let the user try again.
                                } else {
                                    
                                    if objects == nil || objects?.count == 0
                                    {
                                        self.waitingView.removeFromSuperview()
                                        self.isEmailExist = false
                                        self.tableView.reloadData()
                                    }
                                    else
                                    {
                                        let invitedUser = (objects as! [PFUser])[0]
                                        
                                        let pushQuery = PFInstallation.query()
                                        pushQuery!.whereKey("user", equalTo: invitedUser)
                                        let push = PFPush()
                                        push.setQuery(pushQuery) // Set our Installation query
                                        let text = "You were invited for " + (currentChild["child_firstname"] as! String) + " " + (currentChild["child_lastname"] as! String)
                                        push.setMessage(text)
                                        push.sendPushInBackgroundWithBlock(nil)

                                        
                                        let newShare = PFObject(className:"share")
                                        newShare["invited_user"] = invitedUser
                                        newShare["inviting_child"] = currentChild
                                        newShare["invited_user_email"] = invitedUser["email"]
                                        newShare["inviting_user_email"] = PFUser.currentUser()?.email
                                        
                                        newShare.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError? ) -> Void in
                                            
                                            if let error = error {
                                                self.waitingView.removeFromSuperview()
                                                let errorString = error.userInfo["error"] as! NSString
                                                self.showMessage("Sharing Failed.", message: errorString as String)
                                            }
                                            else {
                                                self.isEmailExist = true;
                                                self.invitedUserList .addObject(newShare)
                                                self.tableView.reloadData()
                                                
                                                let paramsDic = NSMutableDictionary()
                                                
                                                paramsDic.setObject(cell.txtEmail.text!, forKey: "toEmail")
                                                paramsDic.setObject((PFUser.currentUser()?.email)!, forKey: "fromEmail")
                                                paramsDic.setObject("Eat Sleep Poop Invitation Email", forKey: "subject")
                                                paramsDic.setObject(text, forKey: "text")

                                                cell.txtEmail.text = ""
                                                PFCloud.callFunctionInBackground("sendMail", withParameters: paramsDic as [NSObject : AnyObject], target: self, selector: #selector(ShareProfileTableViewController.SentMail))                                                
                                            }
                                        }
                                    }
                                }
                            })
                        }
                    }
                })
                
            }

            if isFirstLoad == true
            {
                cell.txtEmail.performSelector(#selector(UIResponder.becomeFirstResponder), withObject: nil, afterDelay: 0.1)
                isFirstLoad = false
            }
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier("NonExistEmailMessageCell") as! NonExistEmailMessageCell
            cell.lblEmptyError.hidden = !isEmailEmpty
            cell.lblErrorDescription.hidden = isEmailExist
            cell.lblEmailValidation.hidden = isEmailValidation
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("InvitedEmailTableViewCell") as! InvitedEmailTableViewCell
            let shareObj = invitedUserList.objectAtIndex(indexPath.row - 5) as! PFObject
            cell.txtEmail.text = ""
            if shareObj["invited_user_email"] != nil
            {
                cell.txtEmail.text = shareObj["invited_user_email"] as? String
            }
            return cell
        }
        
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.row)
        {
        case 0:
            return 20
        case 1:
            return 100;
        case 2:
            return 80
        case 4:
            if isEmailExist == true && isEmailValidation == true && isEmailEmpty == false
            {
                return 20
            }
            return 60
        default:
            return 45
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel){ (action) in
        }
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true){}
        
    }

    
    
    @IBAction func onPressDismiss(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showMessage(title:String, message : String)
    {
        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Dismiss").show()
    }

    func SentMail()
    {
        self.waitingView.removeFromSuperview()
    }

}
