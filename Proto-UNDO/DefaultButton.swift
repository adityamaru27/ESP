//
//  DefaultButton.swift
//  Proto-UNDO
//
//  Created by Santu C on 30/10/16.
//  Copyright © 2016 Curly Brackets. All rights reserved.
//

import UIKit

class DefaultButton: UIButton {

    var nonselectedColor: UIColor! = UIColor.whiteColor()
    /* var shadowLayer: CAShapeLayer!
     
     
     override func layoutSubviews() {
     super.layoutSubviews()
     
     if shadowLayer == nil {
     shadowLayer = CAShapeLayer()
     //  shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).CGPath
     shadowLayer.fillColor = UIColor.whiteColor().CGColor
     
     shadowLayer.shadowColor = UIColor.darkGrayColor().CGColor
     shadowLayer.shadowPath = shadowLayer.path
     shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
     shadowLayer.shadowOpacity = 0.8
     shadowLayer.shadowRadius = 2
     
     layer.insertSublayer(shadowLayer, atIndex: 0)
     //layer.insertSublayer(shadowLayer, below: nil) // also works
     }
     }*/
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setStyle()
    }
    
    override var selected: Bool {
        didSet {
            backgroundColor = !selected ? nonselectedColor : UIColor(red:239/255, green:239/255, blue:244/255, alpha:1.0)
        }
    }
    
    func setStyle() {
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        backgroundColor = UIColor.grayColor()
        
        /*layer.cornerRadius = 15
         layer.borderColor = UIColor(red:200.0/255.0, green:199.0/255.0, blue:204.0/255.0, alpha:1.0).CGColor
         layer.borderWidth = 0.5*/
        titleLabel!.numberOfLines = 0
        titleLabel!.textAlignment = .Center
        
    }
}
