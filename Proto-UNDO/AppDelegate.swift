//
//  AppDelegate.swift
//  Proto-UNDO
//
//  Created by Vlad Konon on 25.07.15.
//  Copyright (c) 2015 Curly Brackets. All rights reserved.
//

import UIKit
import Bolts
import Parse
import SystemConfiguration
import AudioToolbox

import Mixpanel


let viewController = ViewController()
var currentChild : PFObject!
var tabContentVC :  UITabBarController!


var activeRoundedButton: AppDefaultButton!
var selectedRoundedButtonColor : UIColor!
var isAccesaryButton : Bool = false


var activeRoundedButton2: AppDefaultButton!
var selectedRoundedButtonColor2 : UIColor!
var presented:Bool = false



func isTrailPeriod() -> Bool
{
    
    let startDate:NSDate = NSUserDefaults.standardUserDefaults().objectForKey("InstalltionDate") as! NSDate!
    
    let calendar: NSCalendar = NSCalendar.currentCalendar()
    
    let flags = NSCalendarUnit.Day
    let components = calendar.components(flags, fromDate: startDate, toDate: NSDate(), options: [])
    
    print ("Trial Period Days -: \(components.day)")
    
    if (components.day > 5 )
    {
        return true;
    }
    
    return false
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIAlertViewDelegate {

    var window: UIWindow?
    var reach: Reachability?
//    var connectionAlert: UIAlertView!
//    var connectionToolBar: UIToolbar!



    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
        

        Mixpanel.sharedInstanceWithToken("35f00b029b5369e40fad49152e2895bc")

        
        if !userAlreadyExist()
        {
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey:"InstalltionDate")
            
            NSUserDefaults.standardUserDefaults().setObject("oz", forKey:"Measurements")
        }
        
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("Measurements") == nil)
        {
            NSUserDefaults.standardUserDefaults().setObject("oz", forKey:"Measurements")
        }
        
        
       //  NSUserDefaults.standardUserDefaults().setObject("mL", forKey:"Measurements")
        
        //Parse.setApplicationId("VofcHkpj1hhdTM8r5sLnVIdjHN2iRYw5W4jsYjV4", clientKey: "fjKucKpPEQJv1Zf5pioIt4bvf5mhpaTpce7xRz6r")
        
        let configuration=ParseClientConfiguration{
            $0.applicationId="VofcHkpj1hhdTM8r5sLnVIdjHN2iRYw5W4jsYjV4"
            $0.clientKey="fjKucKpPEQJv1Zf5pioIt4bvf5mhpaTpce7xRz6r"
            $0.server="https://parseapi.back4app.com"
            
            //$0.applicationId="VofcHkpj1hhdTM8r5sLnVIdjHN2iRYw5W4jsYjV4"
            //$0.clientKey="fjKucKpPEQJv1Zf5pioIt4bvf5mhpaTpce7xRz6r"
            //$0.server="http://murmuring-taiga-91468.herokuapp.com/parse"        
        }
        Parse.initializeWithConfiguration(configuration)
        
        let userNotificationTypes : UIUserNotificationType = [.Alert ,  .Badge ,  .Sound];
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        
        MKStoreKit.sharedKit().startProductRequest()
        NSNotificationCenter.defaultCenter().addObserverForName(kMKStoreKitProductsAvailableNotification,
            object: nil, queue: NSOperationQueue.mainQueue()) { (note) -> Void in
                print(MKStoreKit.sharedKit().availableProducts)
        }
        
        
        
        validatePurchse()
        
        NSNotificationCenter.defaultCenter().addObserverForName(kMKStoreKitRestoredPurchasesNotification,
            object: nil, queue: NSOperationQueue.mainQueue()) { (note) -> Void in
                print ("Restored Purchases product: \(note.object)")
                
                
                self.validatePurchse()
                
        }
        
       // isTrailPeriod()
        
      //  printFonts()
        
        
        // Allocate a reachability object
        self.reach = Reachability.reachabilityForInternetConnection()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(AppDelegate.reachabilityChanged(_:)),
                                                         name: kReachabilityChangedNotification,
                                                         object: nil)

       
        
//        self.reach!.unreachableBlock = {
//            (let reach: Reachability!) -> Void in
//            dispatch_async(dispatch_get_main_queue()) {
//                
//                
//                //            let connectionController = ReachabilityViewController()
//                self.window?.rootViewController?.presentedViewController?.presentViewController(vc, animated: true, completion: nil)
//                print("UNREACHABLE")
//                
//            }
//            
//            
//        }
//        
//        // Set the blocks
//        self.reach!.reachableBlock = {
//            (let reach: Reachability!) -> Void in
//            
//            // keep in mind this is called on a background thread
//            // and if you are updating the UI it needs to happen
//            // on the main thread, like this:
//            dispatch_async(dispatch_get_main_queue()) {
//                vc.dismissViewControllerAnimated(true, completion: nil)
//                
//                
//            }
//            print("REACHABLE")
//        }
        
        self.reach!.startNotifier()
        
        

        
        return true
    }
    
    func reachabilityChanged(notification: NSNotification) {
        
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("showReachability") as! ReachabilityViewController
//        vc.view.backgroundColor = UIColor.clearColor()
//        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
//        vc.modalPresentationStyle = .OverCurrentContext
        
        //self.window?.rootViewController?.presentedViewController?.definesPresentationContext = true
        //self.window?.rootViewController?.presentedViewController?.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        let connectivityLabel = UILabel()
        connectivityLabel.frame = CGRect(x: 0, y: 0, width:(self.window?.rootViewController?.presentedViewController?.view.frame.width)! , height: 65)
        
        
        if self.reach!.isReachableViaWiFi() || self.reach!.isReachableViaWWAN() {
            dispatch_async(dispatch_get_main_queue()) {
                if(presented)
                {
                    var removeThis = self.window?.rootViewController?.presentedViewController?.view.viewWithTag(100)
                    removeThis?.removeFromSuperview()
                    
                }
                connectivityLabel.backgroundColor = UIColor.greenColor()
                connectivityLabel.text = "Connected"
                connectivityLabel.textColor = UIColor.whiteColor()
                connectivityLabel.textAlignment = NSTextAlignment.Center
                self.window?.rootViewController?.presentedViewController?.view.addSubview(connectivityLabel)

                self.delay(2.0) {
                    connectivityLabel.removeFromSuperview()
                    presented = false
                    
                }
                
            }
            
        }
        else {
            dispatch_async(dispatch_get_main_queue()) {
                connectivityLabel.backgroundColor = UIColor.redColor()
                self.window?.rootViewController?.presentedViewController?.view.addSubview(connectivityLabel)
                connectivityLabel.tag = 100
                connectivityLabel.text = "No Internet Connection"
                connectivityLabel.textColor = UIColor.whiteColor()
                connectivityLabel.textAlignment = NSTextAlignment.Center
                presented=true
                
              
//                self.window?.rootViewController?.presentedViewController?.presentViewController(vc, animated: true, completion: nil)
            }
        }
    }

    func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
    
    func printFonts() {
        for family in UIFont.familyNames()
        {
            
            print("\(family)")
            
            for name in UIFont.fontNamesForFamilyName(family as NSString as String)
            {
                print("   \(name)")
            }
            
        }
    }
    
    func userAlreadyExist() -> Bool {
        if (NSUserDefaults.standardUserDefaults().objectForKey("InstalltionDate") != nil) {
            return true
        }else {
            return false
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackgroundWithBlock(nil)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        PFPush.handlePush(userInfo)
        
        if application.applicationState == .Inactive  {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayloadInBackground(userInfo, block: nil)
//            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
        }
        else
        {
//            application.applicationIconBadgeNumber = 0
//            let installation = PFInstallation.currentInstallation()
//            installation.badge = 0
//            installation.saveInBackgroundWithBlock(nil)
        }
        
    }
    
   
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    
    
    func validatePurchse()
    {
    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "IS_VALID_USER")
    NSUserDefaults.standardUserDefaults().synchronize()
    
    let today = NSDate()
    
    if  MKStoreKit.sharedKit().isProductPurchased("com.esp.pro.monthly")
    {
    if ( today.compare(MKStoreKit.sharedKit().expiryDateForProduct("com.esp.pro.monthly"))  == .OrderedAscending ||  today.compare(MKStoreKit.sharedKit().expiryDateForProduct("com.esp.pro.monthly"))  == .OrderedSame )
    {
    
    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "IS_VALID_USER")
    NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
    }
    else if  MKStoreKit.sharedKit().isProductPurchased("com.esp.pro.yearly")
    {
    
    if ( today.compare(MKStoreKit.sharedKit().expiryDateForProduct("com.esp.pro.yearly"))  == .OrderedAscending ||  today.compare(MKStoreKit.sharedKit().expiryDateForProduct("com.esp.pro.yearly"))  == .OrderedSame )
    {
    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "IS_VALID_USER")
    NSUserDefaults.standardUserDefaults().synchronize()
    
    }
    
    }
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
      validatePurchse()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }



}

