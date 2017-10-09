//
//  BaseTableViewCell.swift
//  ProtoUNDOTest
//
//  Created by Yury on 19/09/15.
//  Copyright © 2015 Yury. All rights reserved.
//

import UIKit

class BaseTableViewCell: SingleSelectionTableViewCell {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let button = AppDefaultButton(frame: CGRectMake(0, 0, 73, 73))
        
      
        var myString:NSString = "\u{25CF}\u{25CF}\u{25CF}\nMore"
        var myMutableString = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "SFUIText-Regular", size: 14.0)!])
       
        
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "SFUIText-Regular", size: 20.0)!, range: NSRange(location:0,length:3))

       button.setAttributedTitle(myMutableString, forState: UIControlState.Normal)
        
        
       // button.setTitle("\u{25CF}\u{25CF}\u{25CF}\nMore", forState: .Normal)
        button.addTarget(self, action: #selector(BaseTableViewCell.onAccessoryButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
        
       
        accessoryView = button
        selectionStyle = .None
    }

    func onAccessoryButtonTapped() {
        selected = true
    }
}
