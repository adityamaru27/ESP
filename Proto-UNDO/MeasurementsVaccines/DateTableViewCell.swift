//
//  DateTableViewCell.swift
//  Proto-UNDO
//
//  Created by Tomasz on 11/8/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {

    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var isSelected:Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        isSelected = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func datePickerValueChanged(sender: AnyObject) {
        txtDate.text = dateFormatter.stringFromDate(datePicker.date);
    }
    
    lazy var dateFormatter : NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter
        }()
}
