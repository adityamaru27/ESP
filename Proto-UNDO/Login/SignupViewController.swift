//
//  SignupViewController.swift
//  Proto-UNDO
//
//  Created by Tomasz on 10/16/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit
import Parse

extension String {
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
                return from ..< to
        }
        return nil
    }
}

class SignupViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var textView: UITextView!

    var isNewProfile :  Bool!
    
    var waitingView : UIView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignupViewController.showNewChildView), name: "Child_Removed_Notification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignupViewController.LogOutAction), name: "LogOut_Notification", object: nil)
        
        // Hide/Show Button for Password
        let btnHide = UIButton(frame: CGRectMake(0, 0, 50, txtPassword.bounds.size.height)) as UIButton!
        btnHide.setTitleColor(UIColor(red: 0, green: 120.0 / 255.0, blue: 1.0, alpha: 1.0), forState: UIControlState.Normal)
        btnHide .setTitle("Hide", forState: UIControlState.Normal)
        btnHide .setTitle("Show", forState: UIControlState.Selected)
        btnHide.selected = false
        btnHide .addTarget(self, action: #selector(SignupViewController.onHide(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        txtPassword.rightView = btnHide
        txtPassword.rightViewMode = UITextFieldViewMode.WhileEditing
        
        
        // WaitingView for Create Acccount
        let waitingLabel = UILabel(frame: CGRectZero) as UILabel!
        waitingLabel.text = "Creating Account"
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
        
        isNewProfile = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.onTapSelf(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        
        // Add tap gesture recognizer to Text View
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.myMethodToHandleTap(_:)))
        
        textView.addGestureRecognizer(tap)
        
        
        
    }
    
    
    
    
    func myMethodToHandleTap(sender: UITapGestureRecognizer) {
        
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.locationInView(myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        // character index at tap location
        let characterIndex = layoutManager.characterIndexForPoint(location, inTextContainer: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // if index is valid then do something.
        if characterIndex < myTextView.textStorage.length {
            
               
            if characterIndex >= 32 && characterIndex <= 45
            {
                let showWebView:WebViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewControllerWithIdentifier("showWebView") as! WebViewController
                
                showWebView.isPrivacy = true
                
                let navController = UINavigationController(rootViewController: showWebView)
                
                self.presentViewController(navController, animated: true, completion: nil)
            }
            
            if characterIndex >= 51 && characterIndex <= 62
            {
                let showWebView:WebViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewControllerWithIdentifier("showWebView") as! WebViewController
                
                let navController = UINavigationController(rootViewController: showWebView)
                
                self.presentViewController(navController, animated: true, completion: nil)
            }
            
            
            
        }
    }

    
    func onTapSelf(gesture : UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
    func LogOutAction()
    {
        self.navigationController?.popToRootViewControllerAnimated(false)
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
    
    // MARK: - Actions
    
    @IBAction func onPressSignup(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        if txtEmail.text == ""
        {
            showMessage("Email is required.")
        }
        else if !validateEmail(txtEmail.text!)
        {
            showMessage("Emai is not valid.")
        }
        else if txtFirstName.text == ""
        {
            showMessage("First Name is requried.")
        }
        else if txtLastName.text == ""
        {
            showMessage("Last Name is requried.")
        }
        else if txtPassword.text == ""
        {
            showMessage("Password is a required field.")
        }
        else if txtPassword.text?.characters.count < 6
        {
            showMessage("Password must be at least 6 \n characters long.")
        }
        else if txtPassword.text?.characters.count > 16
        {
            showMessage("Password must not exceed 16 \n characters long.")
        }
        else
        {
            appDelegate.window?.addSubview(waitingView)
            
            let user = PFUser()
            user.username = txtEmail.text
            user.password = txtPassword.text
            user.email = txtEmail.text
            user["full_name"] = txtFirstName.text! + " " + txtLastName.text!
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                
                self.waitingView.removeFromSuperview()
                
                if let error = error {
                    let errorString = error.userInfo["error"] as! NSString
                    let errorCode = error.userInfo["code"] as! Int
                    NSLog("%d", errorCode)
                    
                    if errorCode == 202 || errorCode == 203 //(202 - username, 203 - email)
                    {
                        UIAlertView(title: "Sign Up Failed", message: errorString as String, delegate: self, cancelButtonTitle: "Dismiss", otherButtonTitles: "Log In").show()
                    }
                    else
                    {
                        UIAlertView(title: "Sign Up Failed", message: errorString as String, delegate: nil, cancelButtonTitle: "Dismiss").show()
                    }
                    
                    // Show the errorString somewhere and let the user try again.
                } else {
                    // Hooray! Let them use the app now.
                    
                    let userDefaults = NSUserDefaults .standardUserDefaults()
                    userDefaults.setObject(self.txtEmail.text, forKey: kUserName)
                    userDefaults.setObject(self.txtPassword.text, forKey: kPassword)
                    
                    let installation = PFInstallation.currentInstallation()
                    installation["user"] = PFUser.currentUser()
                    installation.saveInBackgroundWithBlock(nil)
                    
//                    self.isNewProfile = true
//                    self.performSegueWithIdentifier("NewChildProfileSegue", sender: self)
                    
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
                    tabContentVC.viewControllers = [navVC, logVC, collaborateVC,summaryVC, inviteVC]
                    self.presentViewController(tabContentVC, animated: true, completion: { () -> Void in
                        self.navigationController?.popViewControllerAnimated(false)
                    })

                    
                }
            }
        }
    }
    
    @IBAction func onPressTerms(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://eatsleeppoopapp.com/")!)
    }
    
    // MARK: - General Methods
    
    func showMessage(message : String)
    {
        UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: "Dismiss").show()
    }
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }
    
    
    // MARK: - AlertViewDelegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1
        {
            NSUserDefaults.standardUserDefaults().setObject("login", forKey: "display_view")
            
            self.navigationController?.popToRootViewControllerAnimated(false)
        }
    }

    
    // MARK: - PrepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }


}
