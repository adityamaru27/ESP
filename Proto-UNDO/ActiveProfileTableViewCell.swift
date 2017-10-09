//
//  ActiveProfileTableViewCell.swift
//  Proto-UNDO
//
//  Created by Tomasz on 10/24/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit

class ActiveProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSeparator: UILabel!
    @IBOutlet weak var lblTopSeparator: UILabel!
    @IBOutlet weak var lblBottomSeparator: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
