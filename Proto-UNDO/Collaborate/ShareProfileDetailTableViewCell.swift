//
//  ShareProfileDetailTableViewCell.swift
//  Proto-UNDO
//
//  Created by Tomasz on 10/28/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit

class ShareProfileDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lblChildName: UILabel!
    
    @IBOutlet weak var lblChildDOB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
