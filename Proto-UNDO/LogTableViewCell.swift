//
//  LogTableViewCell.swift
//  Proto-UNDO
//
//  Created by Vlad Konon on 27.07.15.
//  Copyright (c) 2015 Curly Brackets. All rights reserved.
//

import UIKit 

class LogTableViewCell: UITableViewCell {

    @IBOutlet weak var headLine: UILabel!
    @IBOutlet weak var subHeadLine: UILabel!
    @IBOutlet weak var logDetail: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bodyCopy: UILabel!
    @IBOutlet weak var detailButton: UIButton!

   
    
    
    let kImageWidth:CGFloat = 15
    let kImageRight:CGFloat = 4
    

    @IBOutlet weak var vwImages: UIView!
    
 
    @IBOutlet weak var noteHeights: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        resetIcons()
        resetLabels()
        
        self.updateConstraintsIfNeeded()
    }

    func setupCell(event:LogEvent){

        
        self.timeLabel.text = event.dateTimeString(event.time)

        subHeadLine.text = event.title()
        bodyCopy.text = event.note
        
        if event.note != nil
        {
        
        noteHeights.constant = 18
                
        }
        
        
        bodyCopy.textColor = event.getHeadLineTextColor()
        
        logDetail.text = event.getDurationTimes()
        
        
        
        // Marko
        // change breast title
        

        
        headLine.text = event.name
        
        
        
        subHeadLine.text = event.getFullActionName()
        
        if subHeadLine.text == "Not Set"
        {
            subHeadLine.text = event.subtitle().capitalizedString
        }
        
        if event.type.isEqualToString("breast") {
            var szTime:String = ""
            
            
           // szTime = event.dateTimeString(event.time)

            logDetail.text = " " + event.getDurationTimes()
            
            
            
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
                
                
                
                logDetail.text = " " +  event.getDurationTimesforBoth()
                
                if event.timeLeft != nil && event.timeRight != nil
                {
                    
                    if event.timeLeft == event.timeRight
                    {
                         szTime = event.dateTimeStringFromDate(event.timeLeft!)
                    }
                    else
                    {
                    szTime = event.dateTimeStringFromLeftDateRightDate(event.timeLeft!, Right: event.timeRight!)
                    }
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
            
            
            let fontlable : UIFont = self.timeLabel.font
            
            
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

            self.timeLabel.attributedText = attributedString
            
            //self.timeLabel.text = szTime
        }
        else if event.type.isEqualToString("pee")
        {
            if  event.name == event.getFullActionName()
            {
                subHeadLine.text = ""
            }
        }
        else if event.type.isEqualToString("poop")
        {
            if event.title() == "Poops"
            {
                subHeadLine.text = ""
            }
        }
        else if event.type.isEqualToString("note")
        {
            if event.title() == event.name
            {
                subHeadLine.text = ""
            }
        }
        else if event.type.isEqualToString("medicine")
        {
            logDetail.text = ""
            
            if event.getDurationTimes().characters.count > 0
            {
                if subHeadLine.text?.characters.count > 0
                {
                    subHeadLine.text = subHeadLine.text! + ", "
                }
                
                logDetail.text = event.getDurationTimes()
            }
           
            
            if event.quantity > 0
            {
                
                if logDetail.text?.characters.count > 0
                {
                    logDetail.text = logDetail.text! + ", Qty \(event.quantity)"
                }
                else
                {
                    if subHeadLine.text?.characters.count > 0
                    {
                        subHeadLine.text = subHeadLine.text! + ", "
                    }

                    logDetail.text =  "Qty \(event.quantity)"
                }
            }
            
        }
       else if event.type.isEqualToString("pump")
        {
            
            var unit = "oz"
            
            if ((NSUserDefaults.standardUserDefaults().objectForKey("Measurements")?.isEqualToString("oz")) == false) {
                unit = "mL"
            }
            
            
            var szActionString = event.getFullActionName()
            
           // szActionString = szActionString.stringByReplacingOccurrencesOfString("pump", withString: "")
           // szActionString = szActionString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
         
            szActionString = szActionString.capitalizedString

            
            if Int(round(event.value)) > 0
            {
            subHeadLine.text = szActionString + ","
            
            logDetail.text =  String(format: " %d %@", Int(round(event.value)) , unit)
            }
            else
            {
                subHeadLine.text = szActionString
                logDetail.text =  ""
            }
            
            
            if event.action.isEqualToString("left") {
                
                
                if event.leftHours != nil && event.leftMins != nil
                {
                    if event.leftHours > 0 || event.leftMins > 0
                    {
                        
                        if Int(round(event.value)) > 0
                        {
                            logDetail.text =   logDetail.text! + ", " + event.getPickerFormat(event.leftHours!, minutes: event.leftMins!)
                        }
                        else
                        {
                            subHeadLine.text = subHeadLine.text!  + ","
                            logDetail.text =  event.getPickerFormat(event.leftHours!, minutes: event.leftMins!)
                        }
                    }
                }
                
            }
            else  if event.action.isEqualToString("both") {
                
                
                if event.bothHours != nil && event.bothMins != nil
                {
                    if event.bothHours > 0 || event.bothMins > 0
                    {
                        
                        if Int(round(event.value)) > 0
                        {
                            logDetail.text =   logDetail.text! + ", " + event.getPickerFormat(event.bothHours!, minutes: event.bothMins!)
                        }
                        else
                        {
                            subHeadLine.text = subHeadLine.text!  + ","
                            logDetail.text =  event.getPickerFormat(event.bothHours!, minutes: event.bothMins!)
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
                        
                        if Int(round(event.value)) > 0
                        {
                            logDetail.text =  logDetail.text! + ", " + event.getPickerFormat(event.rightHours!, minutes: event.rightMins!)
                        }
                        else
                        {
                            subHeadLine.text = subHeadLine.text!  + ","
                            logDetail.text =  event.getPickerFormat(event.rightHours!, minutes: event.rightMins!)
                        }
                    }
                }
                
            }
            
        }
            
            
        else if event.type.isEqualToString("bottle")
        {
            
            var unit = "oz"
            
            if ((NSUserDefaults.standardUserDefaults().objectForKey("Measurements")?.isEqualToString("oz")) == false) {
                unit = "mL"
            }
            
            print("value - \(event.value)")
            
            if Int(round(event.value)) > 0
            {
                if event.getFullActionName() == event.name
                {
                    subHeadLine.text = ""
                    logDetail.text = ""
                    headLine.text = headLine.text! + String(format: ", %d %@", Int(round(event.value)), unit)
                
                }
                else
                {
                subHeadLine.text = event.getFullActionName()
                
                logDetail.text =  String(format: ", %d %@", Int(round(event.value)), unit)
                }
            }
            else
            {
                if event.getFullActionName() == event.name
                {
                    subHeadLine.text = ""
                }
                else
                {
                
                subHeadLine.text = event.getFullActionName()
                logDetail.text =  ""
                }
            }
            
           
            
                if event.leftHours != nil && event.leftMins != nil
                {
                    if event.leftHours > 0 || event.leftMins > 0
                    {
                        
                        if Int(round(event.value)) > 0
                        {
                            logDetail.text =   logDetail.text! + ", " + event.getPickerFormat(event.leftHours!, minutes: event.leftMins!)
                        }
                        else
                        {
                            subHeadLine.text = subHeadLine.text!  + ","
                            logDetail.text =  event.getPickerFormat(event.leftHours!, minutes: event.leftMins!)
                        }
                    }
                }
                
           
            
        }
          
        else if event.action == "Fell Asleep" || event.action == "Woke Up"
        {
            if event.timeDuration != nil
            {
                subHeadLine.text =  subHeadLine.text! + ","
                logDetail.text = " " + event.timeDuration!
            }
            else
            {
                subHeadLine.text =  event.action  as String
            }
        }
            
        else if event.action == "slept"
        {
           // lblActionExt.hidden = false
            //lblActionExt.text = szAction
            //lblDuration.text = event.timeDuration!
            
            if event.timeDuration != nil
            {
                subHeadLine.text =    "Duration"
                logDetail.text = " " + event.timeDuration!
            }
            else
            {
                subHeadLine.text =  subHeadLine.text! 
            }
            
            if event.dateTimeStringFromDate(event.timeFellAsleep!).rangeOfString("Today") != nil && event.dateTimeStringFromDate(event.timeWokeUp!).rangeOfString("Today") != nil {
                
                self.timeLabel.text = event.dateTimeStringFromDate(event.timeFellAsleep!) + " - " + event.dateTimeStringFromDate(event.timeWokeUp!).stringByReplacingOccurrencesOfString("Today", withString: "")
            }
                
            else if event.dateTimeStringFromDate(event.timeFellAsleep!).rangeOfString("Tomorrow") != nil && event.dateTimeStringFromDate(event.timeWokeUp!).rangeOfString("Tomorrow") != nil {
                
                self.timeLabel.text = event.dateTimeStringFromDate(event.timeFellAsleep!) + " - " + event.dateTimeStringFromDate(event.timeWokeUp!).stringByReplacingOccurrencesOfString("Tomorrow", withString: "")
            }
            else if event.dateTimeStringFromDate(event.timeFellAsleep!).rangeOfString("Yesterday") != nil && event.dateTimeStringFromDate(event.timeWokeUp!).rangeOfString("Yesterday") != nil {
                
                self.timeLabel.text = event.dateTimeStringFromDate(event.timeFellAsleep!) + " - " + event.dateTimeStringFromDate(event.timeWokeUp!).stringByReplacingOccurrencesOfString("Yesterday", withString: "")
            }
            else
            {
                self.timeLabel.text = event.dateTimeStringFromDate(event.timeFellAsleep!) + " - " + event.dateTimeStringFromDate(event.timeWokeUp!)
            }
            
            
            if event.timeFellAsleep == event.timeWokeUp
            {
                self.timeLabel.text = event.dateTimeStringFromDate(event.timeFellAsleep!)
            }
            
            
        }
        
        
        
        for view in vwImages.subviews {
            view.removeFromSuperview()
        }
        
        var x:CGFloat = 0
        
        x = vwImages.frame.size.width
        
        if event.doctorMark == true {
           
            let imageName = "doctor_logs_undo"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            x =  x - 4 - 15
            imageView.frame = CGRect(x: x , y: 5, width: 15, height: 15)
            vwImages.addSubview(imageView)
            
        }
        
       
        if event.babyMark == true {
            
            let imageName = "babysitter_logs_undo"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            x =  x - 4 - 15
            imageView.frame = CGRect(x: x , y: 5, width: 15, height: 15)
            vwImages.addSubview(imageView)
        }
        
        if event.exclamationMark == true {
        
            let imageName = "exclamation_logs_undo"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            x =  x - 4 - 15
            imageView.frame = CGRect(x: x , y: 5, width: 15, height: 15)
            vwImages.addSubview(imageView)
        }
        
        
        if event.starMark == true {
           
            let imageName = "star_logs_undo"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            x =  x - 4 - 15
            imageView.frame = CGRect(x: x , y: 5, width: 15, height: 15)
            vwImages.addSubview(imageView)
        }
        
        
        if let _ = event.imageFile {
            let imageName = "picture_logs_undo"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            x =  x - 4 - 15
            imageView.frame = CGRect(x: x , y: 5, width: 15, height: 15)
            vwImages.addSubview(imageView)
            
        }
       

        
        if event.parentMark == true {
            
            let imageName = "parent_logs_undo"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            x =  x - 4 - 15
            imageView.frame = CGRect(x: x , y: 5, width: 15, height: 15)
            vwImages.addSubview(imageView)
        }
       
        
        if event.type.isEqualToString("note") {
    
            self.contentView.backgroundColor =  event.getprimaryColor()
            self.backgroundColor =  event.getprimaryColor()
        }
        else
        {
        self.contentView.backgroundColor =  event.getsubColor()
        self.backgroundColor =  event.getsubColor()
        }
        
        self.updateConstraintsIfNeeded()
    }
    
    
    
    

    func resetIcons(){

        //parent_width.constant = 0
       
    }
    func resetLabels(){
        headLine.text = nil
        subHeadLine.text = nil
        logDetail.text = nil
        timeLabel.text = nil
        bodyCopy.text = nil
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func getDateFormat(timeInterval:NSTimeInterval) -> String
    {
        let date:NSDate = NSDate(timeIntervalSinceReferenceDate: timeInterval)
        let dateFormatter = NSDateFormatter()
        var text : String = ""
        
        if NSCalendar.currentCalendar().isDateInToday(date) {
            dateFormatter.dateFormat = "h:mm a"
            text = "Today " + dateFormatter.stringFromDate(date).lowercaseString
        }else if NSCalendar.currentCalendar().isDateInTomorrow(date) {
            dateFormatter.dateFormat = "h:mm a"
            text = "Tomorrow " + dateFormatter.stringFromDate(date).lowercaseString
        }else if NSCalendar.currentCalendar().isDateInYesterday(date) {
            dateFormatter.dateFormat = "h:mm a"
            text = "Yesterday " + dateFormatter.stringFromDate(date).lowercaseString
        }else {
            dateFormatter.dateFormat = "MM/dd/yy h:mm a"
            text = dateFormatter.stringFromDate(date).lowercaseString
        }
        
        return text
    }
}
