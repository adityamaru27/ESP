//
//  InviteDetailTableViewController.swift
//  Proto-UNDO
//
//  Created by Tomasz on 10/30/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit
import Parse

class InviteDetailTableViewController: UITableViewController {

    var shareObject : PFObject!
    var isActiveChild : Bool! = false
    @IBOutlet weak var activeSwitchControl: UISwitch!
    
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var lblSenderEmail: UILabel!
    
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnDecline: UIButton!
    
    @IBOutlet weak var lblAcceptDescription: UILabel!
    @IBOutlet weak var lblDeclineDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.topItem!.backBarButtonItem = UIBarButtonItem(title: "Manage", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("onPressBack"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(InviteDetailTableViewController.onPressSave))
        
        self.navigationItem.rightBarButtonItem?.enabled = false
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let childObj = shareObject["inviting_child"] as! PFObject
        
        let firstname = childObj["child_firstname"] as? String
        let lastname = childObj["child_lastname"] as? String
        let childDOB = childObj["child_dob"] as? String
        
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

        self.title = child_fullname + "Invite"
        
        lblFullName.text = firstname! + " " + lastname!
        lblDOB.text = childDOB!
        lblSenderEmail.text = shareObject["inviting_user_email"] as? String
        
        if ( currentChild != nil )
        {
        if currentChild.objectId == childObj.objectId
        {
            isActiveChild = true
            activeSwitchControl.enabled = false
        }
        }

        let accepted = shareObject["accepted"] as? Bool
        activeSwitchControl.enabled = false
        if accepted == nil
        {
            btnAccept.selected = false
            btnDecline.selected = false
        }
        else if accepted == true
        {
            btnAccept.selected = true
            if isActiveChild == false
            {
                activeSwitchControl.enabled = true
                activeSwitchControl.on = false
            }
        }
        else if accepted == false
        {
            btnDecline.selected = true
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func onActiveSwitchChanged(sender: AnyObject) {
        self.contentChanged()
        
        if activeSwitchControl.on == true
        {
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    
    func onPressSave()
    {
        if btnAccept.selected == true
        {
            shareObject["accepted"] = true
        }
        else if btnDecline.selected == true
        {
            shareObject["accepted"] = false
        }
        
        if activeSwitchControl.on == true
        {
            shareObject["active"] = true
            let childObj = shareObject["inviting_child"] as! PFObject
            currentChild = childObj
        }
        
        shareObject.saveInBackgroundWithBlock(nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func contentChanged()
    {
        let accepted = shareObject["accepted"] as? Bool

        self.navigationItem.rightBarButtonItem?.enabled = false
        if accepted == nil
        {
            if btnAccept.selected == true || btnDecline.selected == true
            {
                self.navigationItem.rightBarButtonItem?.enabled = true
            }
        }
        else if accepted == true
        {
            if btnDecline.selected == true
            {
                self.navigationItem.rightBarButtonItem?.enabled = true
            }
        }
        else if accepted == false
        {
            if btnAccept.selected == true
            {
                self.navigationItem.rightBarButtonItem?.enabled = true
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row)
        {
        case 3:     //Accept
            if isActiveChild == false
            {
                btnAccept.selected = true
                btnDecline.selected = false
                
                activeSwitchControl.enabled = true
                self.contentChanged()
            }
            break
        case 5:     //Decline
            if isActiveChild == true
            {
                UIAlertView(title: "You cannot change. \n This child is in active." , message: "", delegate: nil, cancelButtonTitle: "Dismiss").show()
                return
            }
            
            btnAccept.selected = false
            btnDecline.selected = true
            
            activeSwitchControl.enabled = false
            self.contentChanged()
            break
        default:
            break
        }
    }
}
