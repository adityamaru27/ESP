//
//  MemoTableViewCell.swift
//  Proto-UNDO
//
//  Created by Vlad Konon on 06.09.15.
//  Copyright (c) 2015 Curly Brackets. All rights reserved.
//

import UIKit

class MemoTableViewCell: BaseTableViewCell {
    @IBOutlet weak var typeHereButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    
    var item: EventItem!
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryView = nil
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    func getProMessagePopup()
    {
        let alertController = UIAlertController(title: nil, message: "To manage invites, upgrade to Eat Sleep Poop App Pro.\n", preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: "Upgrade to Pro", style: .Default){ (action) in
            
            
            let showESPProVC = UIStoryboard(name: "sleep", bundle: nil).instantiateViewControllerWithIdentifier("showESPProVC")
            
            let navController = UINavigationController(rootViewController: showESPProVC)
            
            
            viewController.presentViewController(navController, animated: true, completion: nil)
            
        }
        alertController.addAction(deleteAction)
        
        let resortAction = UIAlertAction(title: "Restore Pro", style: .Default){ (action) in
            
            
             MKStoreKit.sharedKit().restorePurchases()
            
        }
        alertController.addAction(resortAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel){ (action) in
        }
        alertController.addAction(cancelAction)
        
       viewController.presentViewController(alertController, animated: true){}
        
    }
    
    @IBAction func photoAction(sender: AnyObject) {
        
        if NSUserDefaults.standardUserDefaults().boolForKey("IS_VALID_USER") == false
        {
            if isTrailPeriod()
            {
            self.getProMessagePopup()
            return
            }
        }
        
        viewController.showInput(self, isPhotoTapped: true)
    }

    @IBAction func typeAction(sender: AnyObject) {
        viewController.showInput(self, isPhotoTapped: false)
    }
    
    @IBAction func memoAction(sender: AnyObject) {
        selected = true
        viewController.onAccessoryButtonTapped(item!)
    }
}
