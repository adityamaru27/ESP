//
//  SortFilterViewController.swift
//  Proto-UNDO
//
//  Created by Santu C on 29/10/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit

class SortFilterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var lastSelectedIndexPath: NSIndexPath?
    
    var rowHeight : CGFloat = 45.0
    
    var items: [String] = ["Most Recent First", "Last 24 hours", "Last 2 days", "Last 1 week", "Older than 1 week", "Eat", "Sleep", "Poop", "Medicine", "Note"]
    
    var SortFilterCurrentStatus = [true,false,false,false,false,true,true,true,true,true]
    
    var IconsFilterCurrentStatus = [true,true,true,true,true,true]

    var ImagesName: [String] = ["picture_logs_undo_blue@2x", "babysitter_logs_undo_blue@2x", "star_logs_undo_blue@2x", "parent_logs_undo_blue@2x", "exclamation_logs_undo_blue@2x", "doctor_logs_undo_blue@2x"]
    
    var itemsColorCode: [UIColor?] = [UIColor(hexString: "#EC4A6B"),UIColor(hexString: "#5E6CB2"),UIColor(hexString: "#6E5866"),UIColor(hexString: "#2EBE71"),UIColor(hexString: "#858E99")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = UIColor.clearColor()
        
        if self.view.bounds.height <= 568.0
        {
            self.rowHeight = 40.0
        }
    
        self.tableView.separatorColor = UIColor.clearColor()
        self.view.backgroundColor = UIColor(hexString: "1E1831", alpha: 0.3)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        return self.items.count + 1 ;
    }
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        if indexPath.row == self.items.count
        {
            
            cell.contentView.addSubview(getfooterView()!)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
        }
        else
        {
            let button   = MyCheckBox(type: UIButtonType.Custom) as MyCheckBox
            button.userInteractionEnabled = false
            button.frame = CGRectMake(0, 0, 24, 24)
            
            cell.accessoryView = button
            cell.accessoryView?.frame = CGRectMake(0, 0, 24, 24)
           cell.textLabel!.text = self.items[indexPath.row]
           cell.textLabel!.font = UIFont.systemFontOfSize(16.0)
       
            if self.SortFilterCurrentStatus[indexPath.row] == true
            {
                button.isChecked = true
            }
            else
            {
                button.isChecked = false
            }
          
            
        }
        
        if indexPath.row >= 5 && indexPath.row <= 9
        {
            cell.backgroundColor = itemsColorCode[indexPath.row - 5]
            cell.textLabel!.textColor = UIColor.whiteColor()
        }
        else
        {
            cell.backgroundColor = UIColor.whiteColor()
            cell.textLabel!.textColor = UIColor.blackColor()
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if indexPath.row < 4
        {
        let lineView = UIView(frame: CGRectMake(15, cell.frame.size.height - 1.0, tableView.frame.size.width - 15, 1.0))
        lineView.backgroundColor = UIColor(hexString: "#EFEFF4")
        cell.contentView.addSubview(lineView)
        }
        
        
        return cell
    }
    
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row < self.items.count
        {
        
           tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
            
            let newCell = tableView.cellForRowAtIndexPath(indexPath)
            
            let button   = newCell?.accessoryView as! MyCheckBox
            
            
            if indexPath.row >= 1 && indexPath.row <= 4
            {
                if self.lastSelectedIndexPath != nil
                {
                let oldCell = tableView.cellForRowAtIndexPath(self.lastSelectedIndexPath!)
                
                    let buttonOld   = oldCell?.accessoryView as! MyCheckBox
           
                    
                if self.lastSelectedIndexPath != indexPath
                {
                    //oldCell?.accessoryType = .None
                    buttonOld.isChecked = false
                    
                }
                }

                
                self.lastSelectedIndexPath = indexPath
            }
            
            if button.isChecked == true{
                button.isChecked = false
                
                self.SortFilterCurrentStatus[indexPath.row] = false
                
            }
            else
            {
               // newCell?.accessoryType = .Checkmark
                button.isChecked = true
                
                if indexPath.row >= 1 && indexPath.row <= 4
                {
                    
                    self.SortFilterCurrentStatus[1] = false
                    self.SortFilterCurrentStatus[2] = false
                    self.SortFilterCurrentStatus[3] = false
                    self.SortFilterCurrentStatus[4] = false
                    
                    
                }
                
                self.SortFilterCurrentStatus[indexPath.row] = true
                
            }
            
        }
   }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return self.rowHeight
    }
    
func getfooterView() -> UIView? {
    
    let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, self.rowHeight))
    
    var x: CGFloat
    x=0
    
    var value : Int
    
    var gap: CGFloat
    gap = (self.view.frame.size.width - 6*50)/6
    
    value = Int(gap) * 6
    
    x = (self.view.frame.size.width - 6*50 - CGFloat(value))/2
    
    
    for index in 0 ..< 6
    {
        
        let image = UIImage(named: self.ImagesName[index]) as UIImage?
        
        let button = UIButton(type: UIButtonType.System)
        button.tintColor = UIColor(red:12/255.0, green: 95/255.0, blue: 255.0/255.0, alpha: 1.0)
       // button.tintColor = UIColor.grayColor()
        button.frame = CGRectMake(x, 0, 50, self.rowHeight)
        button.backgroundColor = UIColor.clearColor()
        button.setImage(image, forState: .Normal)
        button.tag = index
        
        button.addTarget(self, action: #selector(SortFilterViewController.buttonClicked(_:)), forControlEvents:.TouchUpInside)
        footerView.addSubview(button)
        
        x=x + gap + 50
    }
    
    
    return footerView
}
        

    func buttonClicked(sender: UIButton) {
        
        
        if self.IconsFilterCurrentStatus [sender.tag] == false
        {
            self.IconsFilterCurrentStatus [sender.tag] = true
            sender.tintColor = UIColor(red:12/255.0, green: 95/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        else
        {
            self.IconsFilterCurrentStatus [sender.tag] = false
            sender.tintColor = UIColor.grayColor()
        }
        
        
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
