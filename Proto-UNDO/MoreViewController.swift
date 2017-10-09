//
//  MoreViewController.swift
//  Proto-UNDO
//
//  Created by Yury on 27/09/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let cells = [["DateCell", "QuantityCell"], ["ParentCell"], ["StarCell"], ["NoteCell"],[]]
    
    @IBOutlet weak var noteCell: MoreNotesTableViewCell!
    var item: EventItem! {
        didSet {
            event = LogEvent(customItem: item, _action: 0)
            title = "\(item.actions[0].name.capitalizedString) More"
        }
    }
    var event: LogEvent!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableViewBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()
        
        navigationController?.navigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(MoreViewController.onSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(MoreViewController.onCancel))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.redColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MoreViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MoreViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @objc func onSave() {
        EventsManager.sharedManager.addEvent(event)
        navigationController?.popViewControllerAnimated(true)
    }
    
    @objc func onCancel() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func parentTapped(sender: UIButton) {
        sender.selected = !sender.selected
    }
    
    
    
    func getProMessagePopup()
    {
        let alertController = UIAlertController(title: nil, message: "To manage invites, upgrade to Eat Sleep Poop App Pro.\n", preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: "Upgrade to Pro", style: .Default){ (action) in
            
            
            let showESPProVC = UIStoryboard(name: "sleep", bundle: nil).instantiateViewControllerWithIdentifier("showESPProVC")
            
            let navController = UINavigationController(rootViewController: showESPProVC)
            
            
            self.presentViewController(navController, animated: true, completion: nil)
            
        }
        alertController.addAction(deleteAction)
        
        let resortAction = UIAlertAction(title: "Restore Pro", style: .Default){ (action) in
            
            
             MKStoreKit.sharedKit().restorePurchases()
            
        }
        alertController.addAction(resortAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel){ (action) in
        }
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true){}
        
    }
    
    @IBAction func photoButtonTapped() {
        
        
        
        if NSUserDefaults.standardUserDefaults().boolForKey("IS_VALID_USER") == false
        {
            if isTrailPeriod()
            {
            self.getProMessagePopup()
            return
            }
        }
        
        noteCell.selected = true
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take a Photo", style: .Default){ (action) in self.getPicture(.Camera) }
        alertController.addAction(takePhotoAction)
        let choosePhotoAction = UIAlertAction(title: "Choose Existing", style: .Default){ (action) in self.getPicture(.PhotoLibrary) }
        alertController.addAction(choosePhotoAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive){ (action) in }
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil);

    }
    // MARK: photo
    func getPicture(sourceType: UIImagePickerControllerSourceType) {
        if !UIImagePickerController.isSourceTypeAvailable(sourceType)
        {
            let alertController = UIAlertController(title: "Camera", message: "Camera on your device is not available!", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel){ (action) in }
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            let imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        picker.dismissViewControllerAnimated(true, completion: nil)
        let original = info[UIImagePickerControllerOriginalImage] as? UIImage
        noteCell.photoImageView.image = original
        event.image = original
        if noteCell.photoImageView.image != nil {
            if noteCell.photoImageViewHeight.constant == 0 {
                tableView?.beginUpdates()
                noteCell.photoImageViewHeight.constant = 210
                noteCell.updateConstraints();
                noteCell.photoImageView.hidden = false
                tableView?.endUpdates()
            }
        }
    }
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cells[indexPath.section][indexPath.row], forIndexPath: indexPath)
        if let moreTableViewCell = cell as? MoreTableViewCell {
            moreTableViewCell.tableView = tableView
            moreTableViewCell.event = event
            if moreTableViewCell.tag == -101 {
                noteCell = moreTableViewCell as! MoreNotesTableViewCell;
            }
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 35 }
        else if section == 1 || section == 2 || section == 3 { return 20 }
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? MoreTableViewCell {
            cell.selectCell(true)
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red:0.936, green:0.936, blue:0.96, alpha:1.0)
        let height = view.bounds.size.height
        let width = view.bounds.size.width
        if section > 0 {
            let topBorder = UIView(frame: CGRectMake(0, 0, width, 1))
            topBorder.backgroundColor = UIColor(red:0.78, green:0.78, blue:0.80, alpha:1.0)
            view.addSubview(topBorder)
        }
        let bottomBorder = UIView(frame: CGRectMake(0, height-1, width, 1))
        bottomBorder.backgroundColor = UIColor(red:0.78, green:0.78, blue:0.80, alpha:1.0)
        view.addSubview(bottomBorder)
    }
    
    // MARK: - Keyboard
    func keyboardWillShow(notification: NSNotification) {
        guard let kbSizeValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let kbDurationNumber = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        
        let lastSection = self.tableView.numberOfSections - 2
        let indexPath = NSIndexPath(forRow: self.tableView.numberOfRowsInSection(lastSection) - 1, inSection: lastSection)
        
        UIView.animateWithDuration(kbDurationNumber.doubleValue){ () -> Void in
            self.tableViewBottom.constant = -kbSizeValue.CGRectValue().height
            self.view.layoutIfNeeded()
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        guard let kbDurationNumber = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        UIView.animateWithDuration(kbDurationNumber.doubleValue){ () -> Void in
            self.tableViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
