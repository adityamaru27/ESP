//
//  ChildDetailViewController.swfit
//  ChildDetailViewController
//
//  Created by Tomasz on 10/19/15.
//  Copyright © 2015 Tomasz. All rights reserved.
//
enum kChildDetailContentCell : Int {
    case SplitterFirst = 0
    case FirstNameCell
    case LastNameCell
    case DOBCell
    case DateTimePicker
    case SplitterLast
}
import UIKit
import Parse

class ChildDetailViewController: UITableViewController {
    
    
    //===============================================
    
    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var txtDOB: UITextField!
    
    //============================================

    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        txtFirstName.text = currentChild["child_firstname"] as? String
        txtLastName.text = currentChild["child_lastname"] as? String
        txtDOB.text = currentChild["child_dob"] as? String

        var child_fullname : String = txtFirstName.text!
        if txtFirstName.text != ""
        {
            child_fullname += " "
        }
        if txtLastName.text != ""
        {
            child_fullname += txtLastName.text!.substringToIndex(txtLastName.text!.startIndex.successor())
        }

        self.title = child_fullname
    }
    
    // MARK: - IBAction slot
    
    @IBAction func onPressCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
      
    lazy var dateFormatter : NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
//        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
//        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter
        }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //       return UITableViewAutomaticDimension
        let type:kChildDetailContentCell = kChildDetailContentCell(rawValue: indexPath.row)!
        
        switch(type)
        {
        case .FirstNameCell:
            return 45
        case .LastNameCell:
            return 45
        case .DOBCell:
            return 45
        case .DateTimePicker:
            return 0
        case .SplitterFirst:
            return 35
        case .SplitterLast:
            return 35
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
}