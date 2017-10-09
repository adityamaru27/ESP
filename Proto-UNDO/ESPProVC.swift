//
//  ESPProVC.swift
//  Proto-UNDO
//
//  Created by Santu C on 22/11/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit
import QuartzCore

class ESPProVC: UITableViewController {

    @IBOutlet weak var lblOneMonth: UILabel!
    @IBOutlet weak var lblOneYear: UILabel!
    
    // MARK: - View life cycle
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden=false
    }
    
    
    @IBAction func onPressDismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

          lblOneMonth.layer.cornerRadius = 11
          lblOneMonth.clipsToBounds = true
          lblOneYear.layer.cornerRadius = 11
         lblOneYear.clipsToBounds = true
        
        tableView.separatorColor = UIColor.clearColor()
        
        
        let gestureOneMonth = UITapGestureRecognizer(target: self, action: #selector(ESPProVC.userTappedOnOneMonth))
       
        lblOneMonth.userInteractionEnabled = true
        lblOneMonth.addGestureRecognizer(gestureOneMonth)
        
        
        let gestureOneYear = UITapGestureRecognizer(target: self, action: #selector(ESPProVC.userTappedOnOneYear))
        
        lblOneYear.userInteractionEnabled = true
        lblOneYear.addGestureRecognizer(gestureOneYear)

        
        NSNotificationCenter.defaultCenter().addObserverForName(kMKStoreKitProductPurchasedNotification,
            object: nil, queue: NSOperationQueue.mainQueue()) { (note) -> Void in
                print ("Purchased product: \(note.object)")
                
                
                
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "IS_VALID_USER")
                NSUserDefaults.standardUserDefaults().synchronize()

        }
        
        
        // Do any additional setup after loading the view.
    }

    
    func userTappedOnOneMonth() {
        MKStoreKit.sharedKit().initiatePaymentRequestForProductWithIdentifier("com.esp.pro.monthly")
    }
    
    func userTappedOnOneYear() {
          MKStoreKit.sharedKit().initiatePaymentRequestForProductWithIdentifier("com.esp.pro.yearly")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
