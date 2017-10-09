//
//  ChildProfileViewController.swift
//  Proto-UNDO
//
//  Created by Tomasz on 10/23/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//
enum kChildProfileContentCell : Int {
    case SplitterFirst = 0
    case ActiveChildCell
    case EditCell
    case Spliter1
    case NewChildCell
}

import UIKit
import Parse

class ChildProfileViewController: UITableViewController {

    @IBOutlet weak var lblCurrentChild: UILabel!
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Child Profile"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if currentChild != nil
        {
        let firstname = currentChild["child_firstname"] as? String
        let lastname = currentChild["child_lastname"] as? String
        
        var child_fullname : String = firstname!
        if firstname != ""
        {
            child_fullname += " "
        }
        if lastname != ""
        {
            child_fullname += lastname!.substringToIndex(lastname!.startIndex.successor())
            child_fullname += "."
        }

        lblCurrentChild.text = child_fullname
        }
    }
    
    // MARK: - IBAction slot
    
    @IBAction func onPressCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //       return UITableViewAutomaticDimension
        let type:kChildProfileContentCell = kChildProfileContentCell(rawValue: indexPath.row)!
        
        switch(type)
        {
        case .ActiveChildCell:
            return 45
        case .EditCell:
            return 45
        case .NewChildCell:
            return 45
        case .SplitterFirst:
            return 35
        default:
            return 20
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let type:kChildProfileContentCell = kChildProfileContentCell(rawValue: indexPath.row)!
        
        switch (type){
        case .ActiveChildCell:
            self.performSegueWithIdentifier("ActiveProfileViewSegue", sender: self)
            break;
        case .EditCell:
            onPressEdit(self)
            break;
        case .NewChildCell:
            onPressNew(self)
            break;
        case .SplitterFirst:
            break;
        default:
            tableView.reloadData()
        }
    }

    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }

    // MARK: - ACTIONS

    @IBAction func onPressEdit(sender: AnyObject) {

        NSLog("parent = %@", (currentChild["parent"] as! PFObject).objectId!);
        
        if (currentChild["parent"] as! PFObject).objectId! == PFUser.currentUser()!.objectId
        {
            self.performSegueWithIdentifier("EditChildProflieSegue", sender: self)
        }
        else
        {
            UIAlertView(title: "You cannot edit invited child.", message: "", delegate: nil, cancelButtonTitle: "Dismiss").show()
        }
    }
    
    @IBAction func onPressNew(sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let childDetailVC = storyboard.instantiateViewControllerWithIdentifier("NewChildProfileView") as! NewChildProfileViewController
        childDetailVC.isNewMoreChild = true
        
        self.navigationController?.pushViewController(childDetailVC, animated: true)
    }
    

}
