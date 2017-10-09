//
//  InviteViewController.swift
//  Proto-UNDO
//
//  Created by Vlad Konon on 25.07.15.
//  Copyright (c) 2015 Curly Brackets. All rights reserved.
//

import UIKit
import Parse

class InviteViewController: BaseViewController {

    @IBOutlet weak var lblUserInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        lblUserInfo.text = "You are logged in as: \n" + PFUser.currentUser()!.email!
    }
    


    @IBAction func onPressLogOut(sender: AnyObject) {
        PFUser.logOut()
        self.dismissViewControllerAnimated(true) { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("LogOut_Notification", object: nil)
        }
    }
}

