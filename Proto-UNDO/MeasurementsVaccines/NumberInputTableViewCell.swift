//
//  NumberInputTableViewCell.swift
//  Proto-UNDO
//
//  Created by Tomasz on 11/8/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit

enum NumberType : Int {
    case WEIGHT_TYPE
    case LENGTH_TYPE
    case HEAD_CIRCUMFERENCE_TYPE
}

class NumberInputTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtInput: UITextField!
    @IBOutlet weak var lblUnit: UILabel!
    
    @IBOutlet weak var lblBottomSeparator: UILabel!
    var cellType : NumberType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellType = NumberType.WEIGHT_TYPE
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//        
//        if textField.text == ""
//        {
//            return true
//        }
//        
//        let type = cellType!
//        
//        switch (type)
//        {
//        case .WEIGHT_TYPE:
//            textField.text = textField.text!.substringToIndex(textField.text!.endIndex.advancedBy(-3))
//            break
//        case .LENGTH_TYPE:
//            textField.text = textField.text!.substringToIndex(textField.text!.endIndex.advancedBy(-3))
//            break
//        case .HEAD_CIRCUMFERENCE_TYPE:
//            textField.text = textField.text!.substringToIndex(textField.text!.endIndex.advancedBy(-3))
//            break
//        }
//
//        return true
//    }
//    
//    func textFieldDidEndEditing(textField: UITextField) {
//        
//        if textField.text == ""
//        {
//            return
//        }
//        
//        let type = cellType!
//        
//        switch (type)
//        {
//        case .WEIGHT_TYPE:
//            textField.text = textField.text! + " lb"
//            break
//        case .LENGTH_TYPE:
//            textField.text = textField.text! + " in"
//            break
//        case .HEAD_CIRCUMFERENCE_TYPE:
//            textField.text = textField.text! + " in"
//            break
//        }
//
//    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
