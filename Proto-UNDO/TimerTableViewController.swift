//
//  TimerTableViewController.swift
//  Proto-UNDO
//
//  Created by robert on 11/5/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit
import AVFoundation

class TimerTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate{

    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var hourPicker: UIPickerView!
    @IBOutlet weak var minPicker: UIPickerView!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var dismissBtn: UIBarButtonItem!
    
    @IBOutlet var hourLbl: UILabel!
    @IBOutlet var secLbl: UILabel!
    @IBOutlet var minLbl: UILabel!
    @IBOutlet var hourView: UIView!
    var sound = NSURL()
    var audioPlayer : AVAudioPlayer = AVAudioPlayer()
   
    var timer = NSTimer()
    let timeInterval:NSTimeInterval = 0.01
    let timerEnd:NSTimeInterval = 0.0
    var timeCount:NSTimeInterval = 100.0
    
    var hours = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
    var mins = [String]()
    var isStart : Bool = false
    var isPause : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hourPicker.delegate = self
        minPicker.delegate = self
        for i in 0 ..< 60
        {
            mins.append(String(i))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        isStart = false
        dismissBtn.title = "Dismiss"
        dismissBtn.tintColor = UIColor(red: 0.0, green: 122/255, blue: 1, alpha: 1)
        startBtn.setTitle("START", forState: .Normal)
        startBtn.setBackgroundImage(UIImage(named: "starttimer"), forState:.Normal)
        hourView.hidden = false;
        isPause = false
        pauseBtn.setTitle("PAUSE", forState: .Normal)
        pauseBtn.setBackgroundImage(UIImage(named: "pausedefault"), forState:.Normal)
    }

    // MARK: - Table view data source
    //Picker Delegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return hours.count
        }
        else if pickerView.tag == 1{
            return mins.count
        }
        else{
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return hours[row]
        }
        else if pickerView.tag == 1{
            return mins[row]
        }
        else{
            return nil
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            }

    @IBAction func onClkStartBtn(sender: AnyObject) {
        setStartOption()
    }
    
    @IBAction func onClkPauseBtn(sender: AnyObject) {
        if isStart{
            if timer.valid{
                pauseBtn.setTitle("PAUSE", forState: .Normal)
                pauseBtn.setBackgroundImage(UIImage(named: "pauseactive"), forState:.Normal)
                timer.invalidate()
                isPause = true
            }
            else{
                timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval,
                    target: self,
                    selector: #selector(TimerTableViewController.timerDidEnd(_:)),
                    userInfo: "Time Done",
                    repeats: true)
                isPause = false;
                pauseBtn.setTitle("PAUSE", forState: .Normal)
                pauseBtn.setBackgroundImage(UIImage(named: "pausedefault"), forState:.Normal)

                
            }
        }
        
    }
    
    @IBAction func onClkDismissBtn(sender: AnyObject) {
        if isStart{
            let alert = UIAlertController(title: "", message: "Are you sure want to \"Quit\"? The timer won't chime.", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let quitBtn : UIAlertAction = UIAlertAction(title: "Yes, quit", style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) -> Void in
                self.timer.invalidate();
                self.dismissViewControllerAnimated(true, completion: nil)
                
            })
            let cancelBtn : UIAlertAction = UIAlertAction(title: "No, don't quit", style:.Default, handler: { (UIAlertAction) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
            })
            
            alert.addAction(quitBtn)
            alert.addAction(cancelBtn)
            if let popoverController = alert.popoverPresentationController {
                popoverController.barButtonItem = self.dismissBtn
            }

            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            dismissViewControllerAnimated(true, completion: nil)
            self.timer.invalidate();
        }
        
    }
    
    func resetTimeCount(){
        timeCount = timerEnd
    }
    
    func timeString(time:NSTimeInterval) {
        let hour = Int(time) / 3600
        let minutes = (Double(time) % 3600) / 60
        let seconds = (time % 3600) % 60
        
        hourLbl.text = String(format:"%02i", hour);
        minLbl.text = String(format:"%02i", Int(minutes));
        secLbl.text = String(format:"%02i", Int(seconds));
//        return String(format:"%02i:%02i:%02i",hour,Int(minutes),Int(seconds))
    }
    
    func timerDidEnd(timer:NSTimer){
        timeCount = timeCount - timeInterval
        if timeCount <= 1 {
            timer.invalidate()
            playAlarm()
            
            let alert = UIAlertController(title: "", message: "Time Done", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelBtn : UIAlertAction = UIAlertAction(title: "OK", style:.Default, handler: { (UIAlertAction) -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
                self.audioPlayer.stop()
                self.setStartOption()
            })
            
            alert.addAction(cancelBtn)
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            timeString(timeCount)
        }
        
    }
    
    func setStartOption(){
        if isStart{
            isStart = false
            dismissBtn.title = "Dismiss"
            dismissBtn.tintColor = UIColor(red: 0.0, green: 122/255, blue: 1, alpha: 1)
            startBtn.setTitle("START", forState: .Normal)
            startBtn.setBackgroundImage(UIImage(named: "starttimer"), forState:.Normal)
            hourView.hidden = false;
        }
        else{
            isStart = true
            hourView.hidden = true;
            dismissBtn.tintColor = UIColor.redColor()
            dismissBtn.title = "Quit"
            startBtn.setTitle("RESET", forState: .Normal)
            startBtn.setBackgroundImage(UIImage(named: "resetred"), forState:.Normal)
            
            timeCount = Double(hourPicker.selectedRowInComponent(0) * 3600) + Double( minPicker.selectedRowInComponent(0) * 60)
            if !timer.valid{
                timeString(timeCount)
                timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval,
                    target: self,
                    selector: #selector(TimerTableViewController.timerDidEnd(_:)),
                    userInfo: "Time Done",
                    repeats: true)
            }
            
        }
        if isPause{
            isPause = false
            pauseBtn.setTitle("PAUSE", forState: .Normal)
            pauseBtn.setBackgroundImage(UIImage(named: "pausedefault"), forState:.Normal)
        }
        else{
//            isPause = true
            pauseBtn.setTitle("PAUSE", forState: .Normal)
            pauseBtn.setBackgroundImage(UIImage(named: "pausedefault"), forState:.Normal)
        }
    }
    func playAlarm() {
        sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sound", ofType: "mp3")!)
        do{
            audioPlayer = try AVAudioPlayer(contentsOfURL:sound)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }catch {
            print("Error getting the audio file")
        }
    }

   
}
