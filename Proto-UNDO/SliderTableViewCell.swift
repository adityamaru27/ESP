//
//  SliderTableViewCell.swift
//  ProtoUNDOTest
//
//  Created by Yury on 18/09/15.
//  Copyright © 2015 Yury. All rights reserved.
//

import UIKit

class SliderTableViewCell: BaseTableViewCell {

    
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak  var valueLabel: UILabel!
    @IBOutlet weak var txtQty: UITextField!
    @IBOutlet weak var descriptionWidth: NSLayoutConstraint!
    
    var accessoryButton: AppDefaultButton!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        accessoryButton = accessoryView as! AppDefaultButton
        
        
        accessoryButton?.layer.cornerRadius = accessoryButton.frame.size.height / 2
        accessoryButton?.layer.borderColor = UIColor.whiteColor().CGColor
        accessoryButton?.layer.borderWidth = 2.0
     
        
       // valueLabel.font = UIFont(name: "SFUIText-Regular", size: 17.0)
        descriptionLabel.font = UIFont(name: "SFUIText-Regular", size: 17.0)
        
       
        
        let keyboardDoneButtonView = UIToolbar.init()
        keyboardDoneButtonView.sizeToFit()
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Done,
                                              target: self,
                                              action: Selector("doneClicked:"))
        
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Cancel,
                                              target: self,
                                              action: Selector("cancelClicked:"))
        
        keyboardDoneButtonView.items = [cancelButton,flexibleSpace, doneButton]
        txtQty.inputAccessoryView = keyboardDoneButtonView
        
        
        
        if ((NSUserDefaults.standardUserDefaults().objectForKey("Measurements")?.isEqualToString("oz")) == true) {
            valueLabel.text = "oz"
        }
        else
        {
            valueLabel.text = "mL"
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SliderTableViewCell.methodOfReceivedNotification(_:)), name:"UndoViewRemove", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SliderTableViewCell.methodOfReceivedNotification2(_:)), name:"UndoViewShow", object: nil)
        
    }
    
    func doneClicked(sender: AnyObject) {
        self.endEditing(true)
        
        if ( txtQty.text! == "" )
        {
            return
        }
        
        if ( item.type == "sleep" )
        {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat =  "HH:mm"
            
            let date = dateFormatter.dateFromString(self.txtQty.text!)
          
            
            let calendar = NSCalendar.currentCalendar()
            

            var logEvent = LogEvent()
            logEvent.action = "slept"
            logEvent.type = "sleep"
           
            let comp = calendar.components([.Hour, .Minute], fromDate: date!)
            
            
            let daysAgo = calendar.dateByAddingUnit(.Minute, value: -((comp.hour * 60) + comp.minute) , toDate: NSDate(), options: [])
            
            logEvent.timeFellAsleep = daysAgo
            logEvent.timeWokeUp = NSDate()
           
            logEvent.leftHours = comp.hour
            logEvent.leftMins = comp.minute

            logEvent.timeDuration = getPickerFormat(logEvent.leftHours!, minutes:  logEvent.leftMins!)
            
            let interval = daysAgo!.timeIntervalSince1970

         //   logEvent.time = interval
        

            
            
            
            EventsManager.sharedManager.addEvent(logEvent)

         //  EventsManager.sharedManager.addEvent(LogEvent(item: item, _action: 0, _value: Float(txtQty.text!)!))
        }
        else
        {
             EventsManager.sharedManager.addEvent(LogEvent(item: item, _action: 0, _value: Float(txtQty.text!)!))
        }
        
        txtQty.text = ""
        
    }
    
    
    
    
    func getPickerFormat(hours:Int,minutes:Int) -> String{
        var text:String = "0 min"
        
        if hours > 0 {
            text = String(format:"%d %@ %d %@",hours,hours > 1 ? "hrs":"hr" ,minutes, minutes > 1 ? "mins":"min")
        }else if minutes>0{
            text = String(format:"%d %@",minutes,minutes > 1 ? "mins":"min" )
        }else{
            text = "0 min"
        }
        return text
    }

    
    func cancelClicked(sender: AnyObject) {
        self.endEditing(true)
        txtQty.text = ""
    }
    
    
    var item : SliderEventItem!{
        didSet {
           // descriptionLabel.text = item.actions[0].name
           // valueLabel.text = String(format: item.infoText, Int(slider.value))
          //  doneButton.setTitle(item.buttonText, forState: .Normal)
            
            if ( item.type == "sleep" )
            {
                descriptionLabel.text = "Duration"
                valueLabel.text = "hr"
                descriptionWidth.constant = 80
                txtQty.placeholder = "00:00"
            }
            else
            {
                descriptionLabel.text = "Qty"
                txtQty.placeholder = "Type here"
                
                
                if ((NSUserDefaults.standardUserDefaults().objectForKey("Measurements")?.isEqualToString("oz")) == true) {
                   valueLabel.text = "oz"
                }
                else
                {
                   valueLabel.text = "mL"
                }
            }
        }
    }
    
    func adjustView() {
       
      //  let showButton = intValue > 0
      //  doneButton.hidden = !showButton
      //  valueTrailing.active = showButton
     //   valueLabel.text = String(format: item!.infoText, intValue)
    }
    
  /*  @IBAction func sliderValueChanged() {
        selected = true
        adjustView()
    }
    */
    @IBAction func doneTapped() {
       // EventsManager.sharedManager.addEvent(LogEvent(item: item, _action: 0, _value: slider.value))
        selected = false
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if !selected {
           // slider.value = 0
            adjustView()
        }
    }
    
    override func onAccessoryButtonTapped() {
        super.onAccessoryButtonTapped()
        
        
        
      if ( activeRoundedButton2 != nil )
       {
            activeRoundedButton2.layer.borderColor = UIColor.whiteColor().CGColor
        }
    
        
        activeRoundedButton2 = accessoryButton ;
        selectedRoundedButtonColor2 = LogEvent(item: item!, _action:0).getprimaryColor()
     
        
        
        viewController.onAccessoryButtonTapped(item!)
    }
    
    
    
    func methodOfReceivedNotification(notification: NSNotification){
        //Take Action on Notification
        
          if ( activeRoundedButton2 != nil )
            {
                activeRoundedButton2.layer.borderColor = UIColor.whiteColor().CGColor
                activeRoundedButton2 = nil
            }
        
    }
    
    
    func methodOfReceivedNotification2(notification: NSNotification){
        //Take Action on Notification
        
        
            if ( activeRoundedButton2 != nil )
            {
                activeRoundedButton2.layer.borderColor =  selectedRoundedButtonColor2.CGColor
            }
    }

}
