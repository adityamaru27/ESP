//
//  PumpMoreSettingData.swift
//  Proto-UNDO
//
//  Created by Santu C on 07/11/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit

class BottleMoreSettingData {
    
    var bIsNotJustNow:Bool = false
    var timeLeft:NSDate? = NSDate.init()
    var bDisplayDescription:Bool = false
    
    var nLeftDurationHours:Int = 0
    var nLeftDurationMinutes:Int = 0
    
    var QuantityPump:Int = 0
    
    var bIsSelectedStar:Bool = false
    var bIsSelectedExclamation:Bool = false
    
    var strNoteText = ""
    var bottleImage : UIImage?
    
    
    
    init () {
    }
}