//
//  LoginViewController.swift
//  Proto-UNDO
//
//  Created by Tomasz on 10/16/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var waitingView : UIView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var waitingLabel : UILabel!
    var isNewProfile : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // WaitingView
        waitingLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 25)) as UILabel!
        waitingLabel.text = "Logging In ..."
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
        
        
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            
                // Hooray! Let them use the app now.
                
                //Email
            waitingLabel.text = "Logging In ..."
            appDelegate.window?.addSubview(waitingView)
            
            
                let shareQuery = PFQuery(className:"share")
                shareQuery.whereKey("invited_user", equalTo: PFUser.currentUser()!)
                shareQuery.includeKey("inviting_child")
                
                shareQuery.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                   
                    
                    if error == nil
                    {
                        if objects != nil && objects?.count != 0
                        {
                            var isActiveExist : Bool = false
                            
                            if let objects=objects{
                                for shareObj in (objects)
                                {
                                    if shareObj["accepted"] != nil && shareObj["accepted"] as! Bool == true && shareObj["active"] as! Bool == true
                                    {
                                        currentChild = shareObj["inviting_child"] as! PFObject
                                        isActiveExist = true
                                        self.showContent()
                                        
                                        break;
                                    }
                                }                            }
                            
                            
                            if isActiveExist == false
                            {
                                self.filterChildren(currentUser)
                                
                            }
                        }
                        else
                        {
                            self.filterChildren(currentUser)
                        }
                    }
                    else
                    {
                        self.filterChildren(currentUser)
                    }
                })
                
            
        }
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.LogOutAction), name: "LogOut_Notification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.showNewChildView), name: "Child_Removed_Notification", object: nil)
        
        // Hide/Show Button for Password
        let btnHide = UIButton(frame: CGRectMake(0, 0, 50, txtPassword.bounds.size.height)) as UIButton!
        btnHide.setTitleColor(UIColor(red: 0, green: 120.0 / 255.0, blue: 1.0, alpha: 1.0), forState: UIControlState.Normal)
        btnHide .setTitle("Hide", forState: UIControlState.Normal)
        btnHide .setTitle("Show", forState: UIControlState.Selected)
        btnHide.selected = false
        btnHide .addTarget(self, action: #selector(LoginViewController.onHide(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        txtPassword.rightView = btnHide
        txtPassword.rightViewMode = UITextFieldViewMode.WhileEditing
        
        
       
        
        isNewProfile = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.onTapSelf(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func onTapSelf(gesture : UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
    func LogOutAction()
    {
        self.txtEmail.text = ""
        self.txtPassword.text = ""
        self.txtPassword.rightViewMode = UITextFieldViewMode.WhileEditing
        self.navigationController?.popToViewController(self, animated: false)
    }
    
    func showNewChildView()
    {
        self.isNewProfile = true
        let storyboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let newChildVC = storyboard.instantiateViewControllerWithIdentifier("NewChildProfileView")
        self.navigationController?.pushViewController(newChildVC, animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isNewProfile == false
        {
            self.navigationController?.navigationBarHidden = true
        }
        isNewProfile = false
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions

    @IBAction func onPressLogin(sender: AnyObject)
    {
        self.view.endEditing(true)
        
        if txtEmail.text == ""
        {
            if txtPassword.text == ""
            {
                showMessage("Both fields are required", message : "")
            }
            else
            {
                showMessage("", message: "Email is required.")
            }
        }
        else if !validateEmail(txtEmail.text!)
        {
            showMessage("Please enter a valid email.", message: "A valid email contains @ and .com or similar.")
        }
        else if txtPassword.text == ""
        {
            showMessage("", message:"Password is a required field.")
        }
        else if txtPassword.text?.characters.count < 6
        {
            showMessage("", message:"Password must be at least 6 \n characters long.")
        }
        else if txtPassword.text?.characters.count > 16
        {
            showMessage("", message:"Password must not exceed 16 \n characters long.")
        }
        else
        {
            waitingLabel.text = "Logging In ..."
            appDelegate.window?.addSubview(waitingView)
            
            let query = PFUser.query() as PFQuery!
            query.whereKey("email", matchesRegex: txtEmail.text!, modifiers: "i")
        

            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                
                if let error = error {
                    self.waitingView.removeFromSuperview()
                    let errorString = error.userInfo["error"] as! NSString
                    UIAlertView(title: "Log In Failed", message: errorString as String, delegate: nil, cancelButtonTitle: "Dismiss").show()

                    // Show the errorString somewhere and let the user try again.
                } else {
                    
                    if objects == nil || objects?.count == 0
                    {
                        self.waitingView.removeFromSuperview()
                        self.showMessage("No account found with that email address.", message: "")
                        
                        return;
                    }
                    
                    let users = objects as! [PFUser]
                    let user = users[0] as PFUser!
                
                    PFUser.logInWithUsernameInBackground(user.username!, password:self.txtPassword.text!) {
                        (user: PFUser?, error: NSError?) -> Void in
                        
                        if let error = error {
                            self.waitingView.removeFromSuperview()
                            let errorString = error.userInfo["error"] as! NSString
                            UIAlertView(title: "Your email and password \n combination failed.", message: "" as String, delegate: self, cancelButtonTitle: "Dismiss", otherButtonTitles:"Reset Password", "Sign Up").show()
                            print(errorString)
                            // Show the errorString somewhere and let the user try again.
                        } else {
                            // Hooray! Let them use the app now.
                            
                            
                            //Email
                            let userDefaults = NSUserDefaults .standardUserDefaults()
                            userDefaults.setObject(self.txtEmail.text, forKey: kUserName)
                            userDefaults.setObject(self.txtPassword.text, forKey: kPassword)
                            
                            let shareQuery = PFQuery(className:"share")
                            shareQuery.whereKey("invited_user", equalTo: PFUser.currentUser()!)
                            shareQuery.includeKey("inviting_child")
                            
                            shareQuery.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                                self.waitingView.removeFromSuperview()
                                
                                if error == nil
                                {
                                    if objects != nil && objects?.count != 0
                                    {
                                        var isActiveExist : Bool = false
                                        
                                        
                                        if let objects=objects{
                                            for shareObj in (objects)
                                            {
                                                if shareObj["accepted"] != nil && shareObj["accepted"] as! Bool == true && shareObj["active"] as! Bool == true
                                                {
                                                    currentChild = shareObj["inviting_child"] as! PFObject
                                                    isActiveExist = true
                                                    self.showContent()
                                                    break;
                                                }
                                            }                                        }
                                        
                                        
                                        if isActiveExist == false
                                        {
                                            self.filterChildren(user)
                                        }
                                    }
                                    else
                                    {
                                        self.filterChildren(user)
                                    }
                                }
                                else
                                {
                                    self.filterChildren(user)
                                }
                            })

                        }
                    }
                }
            })
        }
    }

    func filterChildren(user : PFUser!)
    {
        let childQuery = PFQuery(className:"children")
        childQuery.whereKey("parent", equalTo: user!)
        
        childQuery.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
           
            
            if let error = error
            {
                 self.waitingView.removeFromSuperview()
                
                let errorString = error.userInfo["error"] as! NSString
                UIAlertView(title: "", message: errorString as String, delegate: self, cancelButtonTitle: "Dismiss", otherButtonTitles:"Reset Password", "Sign Up").show()
            }
            else
            {
                if objects == nil || objects?.count == 0
                {
//                    self.isNewProfile = true
//                    self.performSegueWithIdentifier("NewChildProfileSegue", sender: self)
                    
                    let installation = PFInstallation.currentInstallation()
                    installation["user"] = PFUser.currentUser()
                    installation.saveInBackgroundWithBlock(nil)
                    
                    let fileName = NSProcessInfo.processInfo().globallyUniqueString + ".csv"
                    let tempDir : NSString = NSTemporaryDirectory() as NSString
                    let logFilePath = tempDir.stringByAppendingPathComponent(fileName)
                    
                    logFileURL = NSURL(fileURLWithPath: logFilePath)
                    let fileManager = NSFileManager()
                    
                    if fileManager.fileExistsAtPath(logFilePath) == false
                    {
                        fileManager.createFileAtPath(logFilePath, contents: nil, attributes: nil)
                    }
                    
                    DataSource.sharedDataSouce
                    EventsManager.sharedManager
                    
                    let navVC = UINavigationController(rootViewController: viewController)
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let logVC = storyboard.instantiateViewControllerWithIdentifier("LogsNavController")
                    let collaborateVC = UIStoryboard(name: "Collaborate", bundle: nil).instantiateViewControllerWithIdentifier("CollaborateNavView")
                    let inviteVC = storyboard.instantiateViewControllerWithIdentifier("InviteViewController")
                    
                    
                    let summaryVC = UIStoryboard(name: "Collaborate", bundle: nil).instantiateViewControllerWithIdentifier("SummaryNavView")
                    
                    
                    
                    tabContentVC = UITabBarController()
                    tabContentVC.viewControllers = [navVC, logVC, collaborateVC, summaryVC,inviteVC]
                    self.presentViewController(tabContentVC, animated: true, completion:  { () -> Void in
                         self.waitingView.removeFromSuperview()
                    })

                    
                }
                else
                {
                    currentChild = nil
                    //let children = objects as! [PFObject]
                    if let children=objects{
                        for child in children
                        {
                            if child["active"] != nil && child["active"] as! Bool == true
                            {
                                currentChild = child
                                break
                            }
                        }
                    }
                    if currentChild == nil
                    {
                        //currentChild = (objects as! [PFObject])[0]
                        if let unwrappedObjects=objects{
                            currentChild=unwrappedObjects[0]
                        }
                        
                        currentChild["active"] = true
                        currentChild.saveInBackgroundWithBlock(nil)
                    }
                    
                    self.showContent()
                }
            }
        })

    }
    
    func showContent()
    {
        let installation = PFInstallation.currentInstallation()
        installation["user"] = PFUser.currentUser()
        installation.saveInBackgroundWithBlock(nil)
        
        let fileName = NSProcessInfo.processInfo().globallyUniqueString + ".csv"
        let tempDir : NSString = NSTemporaryDirectory() as NSString
        let logFilePath = tempDir.stringByAppendingPathComponent(fileName)
        
        logFileURL = NSURL(fileURLWithPath: logFilePath)
        let fileManager = NSFileManager()
        
        if fileManager.fileExistsAtPath(logFilePath) == false
        {
            fileManager.createFileAtPath(logFilePath, contents: nil, attributes: nil)
        }

        
        //Show Content
        DataSource.sharedDataSouce
        EventsManager.sharedManager
        
        let navVC = UINavigationController(rootViewController: viewController)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logVC = storyboard.instantiateViewControllerWithIdentifier("LogsNavController")
      
        let collaborateVC = UIStoryboard(name: "Collaborate", bundle: nil).instantiateViewControllerWithIdentifier("CollaborateNavView")
        
        let inviteVC = storyboard.instantiateViewControllerWithIdentifier("InviteViewController")
        
        let summaryVC = UIStoryboard(name: "Collaborate", bundle: nil).instantiateViewControllerWithIdentifier("SummaryNavView")
        
        
        tabContentVC = UITabBarController()
        tabContentVC.viewControllers = [navVC, logVC, collaborateVC, summaryVC, inviteVC]
        self.presentViewController(tabContentVC, animated: true, completion:  { () -> Void in
            //                                    self.isNewProfile = true
            //                                    self.performSegueWithIdentifier("NewChildProfileSegue", sender: self)
             self.waitingView.removeFromSuperview()
        })

    }
    
    // MARK: - TextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if txtPassword.text == ""
        {
            txtPassword.rightViewMode = UITextFieldViewMode.Never
        }
    }
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtPassword
        {
            if txtPassword.secureTextEntry
            {
                let updatedString = txtPassword.text?.stringByReplacingCharactersInRange(txtPassword.text!.rangeFromNSRange(range)!, withString: string)
                txtPassword.text = updatedString
                
                return false;
            }
            
            txtPassword.rightViewMode = UITextFieldViewMode.Never
            if (string != "" || (txtPassword.text?.characters.count > 1 && range.length != 0))
            {
                txtPassword.rightViewMode = UITextFieldViewMode.WhileEditing
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == ""
        {
            if textField != txtPassword
            {
                textField.clearButtonMode = UITextFieldViewMode.WhileEditing
            }
            else
            {
                textField.rightViewMode = UITextFieldViewMode.WhileEditing
            }
        }
        else
        {
            if textField != txtPassword
            {
                textField.clearButtonMode = UITextFieldViewMode.Always
            }
            else
            {
                textField.rightViewMode = UITextFieldViewMode.Always
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return true
    }
    
    // MARK: - TextFieldCancel Actions
    
    func onHide(sender : UIButton!)
    {
        sender.selected = !sender.selected
        
        txtPassword.enabled = false
        txtPassword.secureTextEntry = sender.selected
        txtPassword.enabled = true
        txtPassword.becomeFirstResponder()
    }

    // MARK: - AlertViewDelegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 2
        {
            NSUserDefaults.standardUserDefaults().setObject("signup", forKey: "display_view")
            
            self.navigationController?.popToRootViewControllerAnimated(false)
        }
        else if buttonIndex == 1
        {
            self.performSegueWithIdentifier("ResetPasswordSegue", sender: self)
        }
    }
    
    // MARK: - PrepareForSegue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ResetPasswordSegue"
        {
            let resetPasswordVC : ResetPasswordViewController = segue.destinationViewController as! ResetPasswordViewController
            resetPasswordVC.email = validateEmail(txtEmail.text!) == true ? txtEmail.text : ""
        }
    }
    
    
    // MARK: - General Methods
    
    func showMessage(title:String, message : String)
    {
        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Dismiss").show()
    }
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }
    
    lazy var dateFormatter : NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter
        }()
}
