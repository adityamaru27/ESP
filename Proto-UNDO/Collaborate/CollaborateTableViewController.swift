//
//  CollaborateTableViewController.swift
//  Proto-UNDO
//
//  Created by Tomasz on 10/27/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit
import Parse
import MessageUI

class CollaborateTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var imgGuide : UIImageView!
    
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        imgGuide = UIImageView(image: UIImage(named: "guide"))
        imgGuide.frame = UIScreen.mainScreen().bounds
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CollaborateTableViewController.onHideGuide))
        imgGuide.userInteractionEnabled = true
        imgGuide.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if currentChild == nil
        {
            self.navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "New Child Profile", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CollaborateTableViewController.showNewChildProfile(_:)))
        }
        else
        {
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
            
            self.navigationItem.leftBarButtonItem =  UIBarButtonItem(title: child_fullname, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CollaborateTableViewController.onPressChild(_:)))
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
        switch(indexPath.row)
        {
      /*  case 0:
            if currentChild == nil
            {
                self.tabBarController?.view .addSubview(imgGuide)
            }
            else
            {
                exportCSV()
            }
            break*/
        case 0:
            
            if NSUserDefaults.standardUserDefaults().boolForKey("IS_VALID_USER") == false
            {
                if isTrailPeriod()
                {

                    self.getProMessagePopup()
                }
                else
                {
                    if currentChild != nil
                    {
                        let shareProfileVC = UIStoryboard(name: "Collaborate", bundle: nil).instantiateViewControllerWithIdentifier("ShareProfileNavView")
                        self.presentViewController(shareProfileVC, animated: true, completion: nil)
                    }
                    else
                    {
                        self.tabBarController?.view .addSubview(imgGuide)
                    }
                }
            }
            else
            {

            
            if currentChild != nil
            {
                let shareProfileVC = UIStoryboard(name: "Collaborate", bundle: nil).instantiateViewControllerWithIdentifier("ShareProfileNavView")
                self.presentViewController(shareProfileVC, animated: true, completion: nil)
            }
            else
            {
                self.tabBarController?.view .addSubview(imgGuide)
            }
            }
            break
        case 1:
            let shareProfileVC = UIStoryboard(name: "Collaborate", bundle: nil).instantiateViewControllerWithIdentifier("ManageInvitesNavView")
            self.presentViewController(shareProfileVC, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    func exportCSV() {
        if MFMailComposeViewController.canSendMail() == false
        {
            return
        }
        
        let mailController = MFMailComposeViewController()
        mailController.setSubject("Export CSV")
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let user_email = userDefaults.objectForKey("user_email")?.description ?? ""
        mailController.setToRecipients([user_email]);
        mailController.mailComposeDelegate = self
        if let url = logFileURL
        {
            if let data = NSData(contentsOfURL: url)
            {
                let mimeType = "text/csv"
                let fileName = url.lastPathComponent!
                mailController.addAttachmentData(data, mimeType: mimeType, fileName: fileName)
            }
        }
        self.presentViewController(mailController, animated: false, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        controller.dismissViewControllerAnimated( true, completion: nil)
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
    
    func onHideGuide()
    {
        imgGuide.removeFromSuperview()
    }
}
