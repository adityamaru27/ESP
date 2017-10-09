//
//  ReachabilityViewController.swift
//  Proto-UNDO
//
//  Created by Aditya Maru on 2016-12-15.
//  Copyright © 2016 Curly Brackets. All rights reserved.
//

import UIKit

class ReachabilityViewController: UIViewController {
    
    @IBOutlet weak var connectivityBar: UIView!
    var label:UILabel!
    
    override func viewDidLoad() {
        label = UILabel()
        label.text = "No Internet Connection"
        label.textColor = UIColor.whiteColor()
        label.frame = connectivityBar.frame
        label.textAlignment = NSTextAlignment.Center
        connectivityBar.backgroundColor = UIColor.redColor()
        connectivityBar.addSubview(label)
    }
    
  
}
