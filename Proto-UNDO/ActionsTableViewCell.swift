//
//  ActionsTableViewCell.swift
//  ProtoUNDOTest
//
//  Created by Yury on 20/09/15.
//  Copyright © 2015 Yury. All rights reserved.
//

import Parse

import UIKit


extension UIView {
    
    func addShadowView(width:CGFloat=1.0, height:CGFloat=1.0, Opacidade:Float=0.7, maskToBounds:Bool=false, radius:CGFloat=0.5, color:UIColor){
        self.layer.shadowColor = color.CGColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = Opacidade
        self.layer.masksToBounds = maskToBounds
    }
    
}

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}

class ActionsTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var FirstButtonLeadingSpace: NSLayoutConstraint!
    
    @IBOutlet weak var SecondButtonXposition: NSLayoutConstraint!
    @IBOutlet weak var ThirdButtonXposition: NSLayoutConstraint!
    
    @IBOutlet weak private var firstButton: AppDefaultButton!
    @IBOutlet weak private var secondButton: AppDefaultButton!
    @IBOutlet weak var thirdButton: AppDefaultButton!
    
    var accessoryButton: AppDefaultButton!
    
    
    
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        if ( DeviceType.IS_IPHONE_5 )
        {
        
        self.FirstButtonLeadingSpace.constant = -4
        self.SecondButtonXposition.constant = 1
        self.ThirdButtonXposition.constant = 78
        }
        
        
        accessoryButton = accessoryView as! AppDefaultButton
    
        
        accessoryButton?.layer.cornerRadius = accessoryButton.frame.size.height / 2
        accessoryButton?.layer.borderColor = UIColor.whiteColor().CGColor
        accessoryButton?.layer.borderWidth = 2.0
        
        
      //  accessoryButton.backgroundColor = UIColor.grayColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ActionsTableViewCell.methodOfReceivedNotification(_:)), name:"UndoViewRemove", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ActionsTableViewCell.methodOfReceivedNotification2(_:)), name:"UndoViewShow", object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserverForName( kLogObjectAddingNotification,
            object: nil,
            queue: NSOperationQueue.mainQueue())
            {
                
                (notification) -> Void in
                guard let event = notification.object as? LogEvent, item = event.item where item.type == self.item.type && item.type == "medicine" else {
                    return
                }
                if self.item !== item {
                    self.item?.selectedActionIndex = nil
                } else if event.isCustomEvent {
                    self.item?.selectedActionIndex = 0
                } else if event.action == self.item.actions[0].actionID {
                    self.item?.selectedActionIndex = 1
                } else {
                    self.item?.selectedActionIndex = 2
                }
                
               

                self.updateSelection()
        }
    }
    
    var item : EventItem!{
        didSet {
            let actions = item.actions
            firstButton?.hidden = actions.count < 1
            secondButton?.hidden = actions.count < 2
            thirdButton?.hidden = actions.count < 3
            
            
            
            
            if actions.count > 0 {
                firstButton?.setTitle(actions[0].name, forState: .Normal)
               if actions[0].name == "Just Poop"
                {
                    firstButton?.setTitle("Poop", forState: .Normal)
                }
                
                if item.type == "medicine"
                {
                    
                    //Medicine_3
                    
                    if actions[0].name == "Medicine_1"
                    {
                        firstButton?.setTitle("Med_1", forState: .Normal)
                    }
                    else if actions[0].name == "Medicine_2"
                    {
                         firstButton?.setTitle("Med_2", forState: .Normal)
                    }
                    else if actions[0].name == "Medicine_3"
                    {
                         firstButton?.setTitle("Med_3", forState: .Normal)
                    }
                    else if actions[0].name.characters.count > 5
                    {
                        
                        
                       var str =  actions[0].name[actions[0].name.startIndex..<actions[0].name.startIndex.advancedBy(3)]
                        str = str + "..."
                        firstButton?.setTitle(str, forState: .Normal)
                    }
                }
                
                firstButton?.setTitleColor(LogEvent(item: item!, _action:0).getButtonTitleColor(), forState: .Normal)
                
                firstButton?.backgroundColor = LogEvent(item: item!, _action:0).getsubColor()
            
                firstButton.nonselectedColor = LogEvent(item: item!, _action:0).getsubColor()

                firstButton?.layer.cornerRadius = firstButton.frame.size.height / 2
                firstButton?.layer.borderColor = LogEvent(item: item!, _action:0).getsubColor().CGColor
                firstButton?.layer.borderWidth = 2.0
                
                if item.type == "medicine"
                {
                     firstButton?.addShadowView(1.0, height: 1.0, Opacidade: 0.8, maskToBounds: false, radius: 0.5, color: UIColor(red: 11/255, green: 138/255, blue: 70/255, alpha: 1.0) )
                }
                else
                {
            
                firstButton?.addShadowView(1.0, height: 1.0, Opacidade: 0.7, maskToBounds: false, radius: 0.5, color: LogEvent(item: item!, _action:0).getprimaryColor())
                }
                
                
              /*  if item.type == "medicine"
                {
                     firstButton.titleLabel?.numberOfLines = 0
                     firstButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
                }*/
                
                firstButton?.setNeedsLayout()
                firstButton?.layoutIfNeeded()
                
                
            }
            if actions.count > 1 {
                secondButton?.setTitle(actions[1].name, forState: .Normal)
                secondButton?.setTitleColor(LogEvent(item: item!, _action:0).getButtonTitleColor(), forState: .Normal)
                
                secondButton?.backgroundColor = LogEvent(item: item!, _action:0).getsubColor()
                secondButton.nonselectedColor = LogEvent(item: item!, _action:0).getsubColor()
                

                secondButton?.layer.cornerRadius = secondButton.frame.size.height / 2
                secondButton?.layer.borderColor = LogEvent(item: item!, _action:0).getsubColor().CGColor
                secondButton?.layer.borderWidth = 2.0
                
                secondButton?.addShadowView(1.0, height: 1.0, Opacidade: 0.7, maskToBounds: false, radius: 0.5, color: LogEvent(item: item!, _action:0).getprimaryColor())
                
               // secondButton.titleLabel?.numberOfLines = 0
             //   secondButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
                
                secondButton?.setNeedsLayout()
                secondButton?.layoutIfNeeded()
            }
            if actions.count > 2 {
                
                thirdButton?.setTitle(actions[2].name, forState: .Normal)
                
                thirdButton?.setTitleColor(LogEvent(item: item!, _action:0).getButtonTitleColor(), forState: .Normal)
                
                thirdButton?.backgroundColor = LogEvent(item: item!, _action:0).getsubColor()
                
                thirdButton.nonselectedColor = LogEvent(item: item!, _action:0).getsubColor()
                
                thirdButton?.layer.cornerRadius = thirdButton.frame.size.height / 2
                thirdButton?.layer.borderColor = LogEvent(item: item!, _action:0).getsubColor().CGColor
                thirdButton?.layer.borderWidth = 2.0
                
                thirdButton?.addShadowView(1.0, height: 1.0, Opacidade: 0.7, maskToBounds: false, radius: 0.5, color: LogEvent(item: item!, _action:0).getprimaryColor())
                
               // thirdButton.titleLabel?.numberOfLines = 0
              //  thirdButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
                thirdButton?.setNeedsLayout()
                thirdButton?.layoutIfNeeded()
                
            }
            updateSelection()
        }
    }
    
    
    func reDrawView()
    {
        let actions = item.actions
        
        if actions.count > 0 {
            firstButton?.setTitle(actions[0].name, forState: .Normal)
            if actions[0].name == "Just Poop"
            {
                firstButton?.setTitle("Poop", forState: .Normal)
            }
            
            if item.type == "medicine"
            {
                
                //Medicine_3
                
                if actions[0].name == "Medicine_1"
                {
                    firstButton?.setTitle("Med_1", forState: .Normal)
                }
                else if actions[0].name == "Medicine_2"
                {
                    firstButton?.setTitle("Med_2", forState: .Normal)
                }
                else if actions[0].name == "Medicine_3"
                {
                    firstButton?.setTitle("Med_3", forState: .Normal)
                }
                else if actions[0].name.characters.count > 5
                {
                    
                    
                    var str =  actions[0].name[actions[0].name.startIndex..<actions[0].name.startIndex.advancedBy(3)]
                    str = str + "..."
                    firstButton?.setTitle(str, forState: .Normal)
                }
            }
            
            firstButton?.setTitleColor(LogEvent(item: item!, _action:0).getButtonTitleColor(), forState: .Normal)
            
            firstButton?.backgroundColor = LogEvent(item: item!, _action:0).getsubColor()
            
            firstButton.nonselectedColor = LogEvent(item: item!, _action:0).getsubColor()
            
            firstButton?.layer.cornerRadius = firstButton.frame.size.height / 2
            firstButton?.layer.borderColor = LogEvent(item: item!, _action:0).getsubColor().CGColor
            firstButton?.layer.borderWidth = 2.0
            if item.type == "medicine"
            {
                 firstButton?.addShadowView(1.0, height: 1.0, Opacidade: 0.8, maskToBounds: false, radius: 0.5, color: UIColor(red: 11/255, green: 138/255, blue: 70/255, alpha: 1.0) )
            }
            else
            {
                
                firstButton?.addShadowView(1.0, height: 1.0, Opacidade: 0.7, maskToBounds: false, radius: 0.5, color: LogEvent(item: item!, _action:0).getprimaryColor())
            }
            
            
            /*  if item.type == "medicine"
             {
             firstButton.titleLabel?.numberOfLines = 0
             firstButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
             }*/
            
            firstButton?.setNeedsLayout()
            firstButton?.layoutIfNeeded()
            
            
        }

    }
    
    func setButtonBorder(isBorder:Bool)
    {
        if ( activeRoundedButton != nil )
        {
        if ( isBorder == true )
        {
            //self.activeButton.backgroundColor = UIColor.clearColor()
            activeRoundedButton.layer.borderColor = LogEvent(item: item!, _action:0).getprimaryColor().CGColor
           
        }
        else
        {
            
             activeRoundedButton.layer.borderColor = selectedRoundedButtonColor.CGColor
        }
        }
        
    }
    
    func methodOfReceivedNotification(notification: NSNotification){
        //Take Action on Notification
        
        if ( isAccesaryButton == true )
        {
            if ( activeRoundedButton != nil )
            {
             activeRoundedButton.layer.borderColor = UIColor.whiteColor().CGColor
             activeRoundedButton = nil
            }
        }
        else
        {
            setButtonBorder(false)
            activeRoundedButton = nil
        }
    }
    
    
    func methodOfReceivedNotification2(notification: NSNotification){
        //Take Action on Notification
        
       if ( isAccesaryButton == true )
       {
        if ( activeRoundedButton != nil )
        {
             activeRoundedButton.layer.borderColor =  selectedRoundedButtonColor.CGColor
        }
       }
    }

    
    @IBAction func buttonOneTapped(sender: AppDefaultButton) {
        selected = true
        
        // Marko
        // check PF Login User
        let currUser = PFUser.currentUser()
        if currUser == nil {
            return
        }
    
        setButtonBorder(false)
        isAccesaryButton = false
        
        if (LogEvent(item: item!, _action:0).type != "medicine" )
        {
            activeRoundedButton = sender;
            selectedRoundedButtonColor = LogEvent(item: item!, _action:0).getsubColor()
            setButtonBorder(true)
        }
        
        //
     
        
      EventsManager.sharedManager.addEvent(LogEvent(item: item!, _action:0))
        
    }
    
    @IBAction func buttonThirdTappped(sender: AnyObject) {
        
        
        setButtonBorder(false)
         isAccesaryButton = false
        activeRoundedButton = sender as! AppDefaultButton;
        selectedRoundedButtonColor = LogEvent(item: item!, _action:0).getsubColor()
        setButtonBorder(true)
    
        
        selected = true
        EventsManager.sharedManager.addEvent(LogEvent(item: item!, _action:2))
    }
    
    
    @IBAction func buttonTwoTapped(sender: AppDefaultButton) {
        
        
        setButtonBorder(false)
        
        isAccesaryButton = false
        activeRoundedButton = sender;
        selectedRoundedButtonColor = LogEvent(item: item!, _action:0).getsubColor()
        setButtonBorder(true)
       
        selected = true
        EventsManager.sharedManager.addEvent(LogEvent(item: item!, _action:1))
    }
    
    func updateSelection() {
        accessoryButton.selected = (item!.selectedActionIndex == 0)
        firstButton.selected = (item!.selectedActionIndex == 1)
        secondButton.selected = (item!.selectedActionIndex == 2)
        thirdButton.selected = (item!.selectedActionIndex == 3)
    }
    
    override func onAccessoryButtonTapped() {
        super.onAccessoryButtonTapped()
        
        if (isAccesaryButton == false)
        {
            setButtonBorder(false)
        }
        else
        {
            if ( activeRoundedButton != nil )
            {
                activeRoundedButton.layer.borderColor = UIColor.whiteColor().CGColor
            }
        }
        isAccesaryButton = true
        activeRoundedButton = accessoryButton ;
        selectedRoundedButtonColor = LogEvent(item: item!, _action:0).getprimaryColor()
        
        viewController.onAccessoryButtonTapped(item!)
        
        
    }
}
