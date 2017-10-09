//
//  InputEmailDescriptionCell.swift
//  Proto-UNDO
//
//  Created by Tomasz on 10/30/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit

class InputEmailDescriptionCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if UIScreen.mainScreen().bounds.size.width == 320
        {
            lblDescription.font = UIFont.systemFontOfSize(12.0)
        }
        else
        {
            lblDescription.font = UIFont.systemFontOfSize(14.0)
        }

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
