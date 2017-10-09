//
//  VaccineTableViewCell.swift
//  Proto-UNDO
//
//  Created by Tomasz on 11/9/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit

enum VaccineCellType : Int
{
    case INPUT_CELL
    case DISPLAY_CELL
}

class VaccineTableViewCell: UITableViewCell {

    @IBOutlet weak var imgDisclosure: UIImageView!
    @IBOutlet weak var txtVaccine: UITextField!
    @IBOutlet weak var txtVaccineRightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellType(cellType : VaccineCellType)
    {
        switch (cellType)
        {
        case .INPUT_CELL:
            imgDisclosure.hidden = false
            txtVaccineRightConstraint.constant = 30
            break
            
        case .DISPLAY_CELL:
            imgDisclosure.hidden = true
            txtVaccineRightConstraint.constant = 10
            break
        }
    }

}
