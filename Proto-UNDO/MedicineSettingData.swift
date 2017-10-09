//
//  MedicineSettingData.swift
//  Proto-UNDO
//
//  Created by Santu C on 15/11/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit

class MedicineSettingData {
    
    var time:NSTimeInterval = 0.0
    var Quantity:Int = 0
    
    var bIsSelectedStar:Bool = false
    var bIsSelectedExclamation:Bool = false
    var bIsSelectedParent:Bool = false
    
    
    var nLeftDurationHours:Int = 0
    var nLeftDurationMinutes:Int = 0
  
    
    var strNoteText = ""
    var bottleImage : UIImage?
    
    
    var bIsNotJustNow:Bool = false
    var timeLeft:NSDate? = NSDate.init()
   
    
    
    init () {
    }
}