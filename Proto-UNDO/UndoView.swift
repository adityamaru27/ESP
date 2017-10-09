//
//  UndoView.swift
//  Proto-UNDO
//
//  Created by Admin on 10/17/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit
import Mixpanel

class UndoView: UIView {
    
    var view: UIView!
    @IBOutlet weak var durationWidth: NSLayoutConstraint!
    
   
    @IBOutlet weak var lblEvent: UILabel!
    @IBOutlet weak var lblDurationStart: NSLayoutConstraint!
    @IBOutlet weak var lblAction: UILabel!
    @IBOutlet weak var lblActionExt: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    
    @IBOutlet weak var image_width: NSLayoutConstraint!
    @IBOutlet weak var star_width: NSLayoutConstraint!
    @IBOutlet weak var exclaim_width: NSLayoutConstraint!
    @IBOutlet weak var baby_width: NSLayoutConstraint!
    @IBOutlet weak var doctor_width: NSLayoutConstraint!
    
    @IBOutlet weak var parent_width: NSLayoutConstraint!
    @IBOutlet weak var parent_right: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var image_right: NSLayoutConstraint!
    @IBOutlet weak var star_right: NSLayoutConstraint!
    @IBOutlet weak var exclaim_right: NSLayoutConstraint!
    @IBOutlet weak var baby_right: NSLayoutConstraint!
    @IBOutlet weak var doctor_right: NSLayoutConstraint!
    
    let kImageWidth:CGFloat = 15
    let kImageRight:CGFloat = 4
    
    
    
  
    
    var event: LogEvent? = nil {
        didSet {
            guard let event = event else { return }
            
            lblTime.text = event.dateTimeString(event.time)
            lblNote.text = event.note
            
            lblEvent.text = event.name
            
            var szAction = event.getFullActionName()
            
            // breast process
            if event.type == "breast" {
                
                lblAction.text = szAction
                lblDuration.text = event.getDurationTimes()
                
                var szTime:String = ""
                
               

                
                if event.action.isEqualToString("right") {
                    
                    if event.timeRight != nil
                    {
                     szTime = event.dateTimeStringFromDate(event.timeRight!)
                    }
                    else
                    {
                        szTime = event.dateTimeString(event.time)
                    }
                }
                else if event.action.isEqualToString("left") {
                    if event.timeLeft != nil
                    {
                        szTime = event.dateTimeStringFromDate(event.timeLeft!)
                    }
                    else
                    {
                         szTime = event.dateTimeString(event.time)
                    }
                }
                else if event.action.isEqualToString("both") {
                    
                    if event.timeLeft != nil && event.timeRight != nil
                    {
                    szTime = event.dateTimeStringFromLeftDateRightDate(event.timeLeft!, Right: event.timeRight!)
                    }
                    else if event.timeLeft != nil
                    {
                        
                        szTime = event.dateTimeStringFromDateCustom(event.timeLeft!,prefixString: "L ");
                        
                    }
                    else if event.timeRight != nil
                    {
                        szTime = event.dateTimeStringFromDateCustom(event.timeRight!,prefixString: "R ");
                    }
                    else
                    {
                        szTime = event.dateTimeString(event.time)
                    }
                    
                }
                
                
                let fontlable : UIFont = lblTime.font
                
                
                let nsText = szTime as NSString
                let textRange = NSMakeRange(0, nsText.length)
                let attributedString =  NSMutableAttributedString(
                    string: szTime,
                    attributes: [NSFontAttributeName:fontlable])
                
                nsText.enumerateSubstringsInRange(textRange, options: .ByWords, usingBlock: {
                    (substring, substringRange, _, _) in
                    
                    if (substring == "L") {
                        attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(fontlable.pointSize), range: substringRange)
                    }
                    else if (substring == "R") {
                        attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(fontlable.pointSize), range: substringRange)
                    }
                })
          
                lblTime.attributedText = attributedString
                

                
                

                lblAction.hidden = false
                lblDuration.hidden = false
                lblActionExt.hidden = true
            }
            else if event.type == "pump"
            {
               // String(format: "%d oz", Int(event.value))
                
                var unit = "oz"
                
                if ((NSUserDefaults.standardUserDefaults().objectForKey("Measurements")?.isEqualToString("oz")) == false) {
                    unit = "mL"
                }

                lblAction.hidden = false
                lblDuration.hidden = false
                lblActionExt.hidden = true
                
                szAction = szAction.capitalizedString
                
             //   szAction = szAction.stringByReplacingOccurrencesOfString("pump", withString: "")
                
              //  szAction = szAction.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
         
                
                if Int(event.value) > 0
                {
                
                lblDuration.text = String(format: "%d %@", Int(round(event.value)),unit)
                lblAction.text = szAction + ","
                    
                }
                else
                {
                    lblAction.text = szAction 
                    lblDuration.hidden = true
                }
                
                
                if event.action.isEqualToString("left") {
                    
                    
                    if event.leftHours != nil && event.leftMins != nil
                    {
                        if event.leftHours > 0 || event.leftMins > 0
                        {
                            
                            if Int(event.value) > 0
                            {
                                lblDuration.text =   lblDuration.text! + ", " + event.getPickerFormat(event.leftHours!, minutes: event.leftMins!)
                            }
                            else
                            {
                                lblDuration.hidden = false
                                lblAction.text = szAction + ","
                                lblDuration.text =  event.getPickerFormat(event.leftHours!, minutes: event.leftMins!)
                            }
                        }
                    }
                
                }
                else  if event.action.isEqualToString("both") {
                    
                    
                    if event.bothHours != nil && event.bothMins != nil
                    {
                        if event.bothHours > 0 || event.bothMins > 0
                        {
                            
                            if Int(event.value) > 0
                            {
                                lblDuration.text =   lblDuration.text! + ", " + event.getPickerFormat(event.bothHours!, minutes: event.bothMins!)
                            }
                            else
                            {
                                lblDuration.hidden = false
                                lblAction.text = szAction + ","
                                lblDuration.text =  event.getPickerFormat(event.bothHours!, minutes: event.bothMins!)
                            }
                        }
                    }
                    
                }
 
                else
                {
                    if event.rightMins != nil && event.rightHours != nil
                    {
                        if event.rightHours > 0 || event.rightMins > 0
                        {
                            
                            if Int(event.value) > 0
                            {
                                lblDuration.text =  lblDuration.text! + ", " + event.getPickerFormat(event.rightHours!, minutes: event.rightMins!)
                            }
                            else
                            {
                                lblDuration.hidden = false
                                lblAction.text = szAction + ","
                                lblDuration.text =  event.getPickerFormat(event.rightHours!, minutes: event.rightMins!)
                            }
                        }
                    }

                }

                
                
                
            }
           
            else if event.type == "bottle"
            {
                // String(format: "%d oz", Int(event.value))
                
                
                lblAction.hidden = false
                lblDuration.hidden = false
                lblActionExt.hidden = true
                
                var unit = "oz"
                
                if ((NSUserDefaults.standardUserDefaults().objectForKey("Measurements")?.isEqualToString("oz")) == false) {
                    unit = "mL"
                }
                if szAction == event.name
                {
                    szAction = ""
                }
                
                if Int(event.value) > 0
                {
                    
                    lblDuration.text = String(format: "%d %@", Int(round(event.value)),unit)
                    if szAction.characters.count == 0
                    {
                        lblEvent.text = lblEvent.text! + ", " + String(format: "%d %@", Int(round(event.value)),unit)
                        lblAction.text = ""
                        lblAction.hidden = true
                        lblDuration.hidden = true
                    }
                    else
                    {
                    lblAction.text = szAction + ","
                    }
                    
                }
                else
                {
                    lblAction.text = szAction
                    lblDuration.hidden = true
                }
                
                    
                    if event.leftHours != nil && event.leftMins != nil
                    {
                        if event.leftHours > 0 || event.leftMins > 0
                        {
                            
                            if Int(event.value) > 0
                            {
                                lblDuration.text =   lblDuration.text! + ", " + event.getPickerFormat(event.leftHours!, minutes: event.leftMins!)
                            }
                            else
                            {
                                lblDuration.hidden = false
                                lblAction.text = szAction + ","
                                lblDuration.text =  event.getPickerFormat(event.leftHours!, minutes: event.leftMins!)
                            }
                        }
                    }
                
                
            }
            else if event.type == "medicine"
            {
                lblAction.hidden = false
                lblActionExt.hidden = true
                lblAction.text = szAction
                lblActionExt.text = ""
                
                lblDuration.text = ""
                
                if event.leftHours != nil && event.leftMins != nil
                {
                    if event.leftHours > 0 || event.leftMins > 0
                    {
                        lblAction.text = szAction + ","
                        
                        lblDuration.text = " " + event.getPickerFormat(event.leftHours!, minutes: event.leftMins!)
                    }
                }
                
                
                if event.quantity != 0
                {
                 
                    if lblDuration.text?.characters.count == 0
                    {
                        lblAction.text = szAction + ","
                        
                        lblDuration.text =  " Qty \(event.quantity)"
                        
                    }
                    else
                    {
                    
                        lblDuration.text = lblDuration.text! + ", Qty \(event.quantity)"
                    }
                  
                }

            }
            else if event.action == "slept"
            {
                lblActionExt.hidden = false
                lblActionExt.text = "Duration"
                if event.timeDuration != nil
                {
                    if event.timeDuration?.characters.count > 0
                    {
                       // lblActionExt.text = lblActionExt.text!  + ""
                        lblDuration.text = " " + event.timeDuration!
                        lblDurationStart.constant = 20
                    }
                }
                else
                    
                {
                    lblDuration.text = ""
                }
                    
                
                if event.dateTimeStringFromDate(event.timeFellAsleep!).rangeOfString("Today") != nil && event.dateTimeStringFromDate(event.timeWokeUp!).rangeOfString("Today") != nil {
                 
                    lblTime.text = event.dateTimeStringFromDate(event.timeFellAsleep!) + " - " + event.dateTimeStringFromDate(event.timeWokeUp!).stringByReplacingOccurrencesOfString("Today", withString: "")
                }
                
                else if event.dateTimeStringFromDate(event.timeFellAsleep!).rangeOfString("Tomorrow") != nil && event.dateTimeStringFromDate(event.timeWokeUp!).rangeOfString("Tomorrow") != nil {
                    
                    lblTime.text = event.dateTimeStringFromDate(event.timeFellAsleep!) + " - " + event.dateTimeStringFromDate(event.timeWokeUp!).stringByReplacingOccurrencesOfString("Tomorrow", withString: "")
                }
                else if event.dateTimeStringFromDate(event.timeFellAsleep!).rangeOfString("Yesterday") != nil && event.dateTimeStringFromDate(event.timeWokeUp!).rangeOfString("Yesterday") != nil {
                    
                    lblTime.text = event.dateTimeStringFromDate(event.timeFellAsleep!) + " - " + event.dateTimeStringFromDate(event.timeWokeUp!).stringByReplacingOccurrencesOfString("Yesterday", withString: "")
                }
                else
                {
                    
                lblTime.text = event.dateTimeStringFromDate(event.timeFellAsleep!) + " - " + event.dateTimeStringFromDate(event.timeWokeUp!)
                }
                
                if event.timeFellAsleep == event.timeWokeUp
                {
                    lblTime.hidden = false
                    event.timeFellAsleep = NSDate()
                    event.timeWokeUp = event.timeFellAsleep
                    
                    lblTime.text = event.dateTimeStringFromDate(event.timeFellAsleep!)
                }
                
                lblAction.hidden = true
                lblDuration.hidden = false
                
                
            }
            else {
                lblAction.hidden = true
                lblDuration.hidden = true
                lblActionExt.hidden = false
                
                
                if szAction == "Not Set"
                {
                    szAction = event.subtitle().capitalizedString
                }
                
                if event.type.isEqualToString("poop")
                {
                    if szAction == "Poops"
                    {
                        szAction = ""
                    }
                }
                else if event.type.isEqualToString("sleep")
                {
                    szAction = event.action  as String
                    
                }
                else
                {
                    if szAction == event.name
                    {
                        szAction = ""
                    }

                    
                }
                
               // lblAction.text = szAction
                lblActionExt.text = szAction
            }
            
            // display icons
            if (event.image != nil || event.imageFile != nil){
                image_width.constant = kImageWidth
                image_right.constant = kImageRight
            }
            else {
                image_width.constant = 0
                image_right.constant = 0
            }
            
            
            
            if event.parentMark == false {
                parent_right.constant = 0
                parent_width.constant = 0
            }
            else {
                parent_width.constant = kImageWidth
                parent_right.constant = kImageRight
            }

            
            
            
            //
            if event.starMark == false {
                star_width.constant = 0
                star_right.constant = 0
            }
            else {
                star_width.constant = kImageWidth
                star_right.constant = kImageRight
            }
            
            if event.exclamationMark == false {
                exclaim_width.constant = 0
                exclaim_right.constant = 0
                
            }
            else {
                exclaim_width.constant = kImageWidth
                exclaim_right.constant = kImageRight
            }
            
            if event.doctorMark == false {
                doctor_width.constant = 0
                doctor_right.constant = 0
            }
            else {
                doctor_width.constant = kImageWidth
                doctor_right.constant = kImageRight
            }
            
            if event.babyMark == false {
                baby_width.constant = 0
                baby_right.constant = 0
            }
            else {
                baby_width.constant = kImageWidth
                baby_right.constant = kImageRight
            }
            
            
            view.backgroundColor = event.getsubColor()
            view.updateConstraints()
            view.layoutIfNeeded()
            
            
            
            var tracker = GAI.sharedInstance().defaultTracker
            tracker.send(GAIDictionaryBuilder.createEventWithCategory(event.type as String, action:event.type as String , label: "", value: nil).build() as [NSObject : AnyObject])

            let mixpanel = Mixpanel.sharedInstance()
            let properties = ["Event": event.type]
            mixpanel.track("Event selected", properties: properties)

        }
        
}
    
    
    @IBAction func undoTapped() {
        EventsManager.sharedManager.undoLastEvent()
    }
    
    
    func xibSetup() {
        
        view = loadViewFromNib()
        
        view.frame = bounds
        
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        addSubview(view)
        
        
}
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "UndoView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        xibSetup()
    }

}
