//
//  PumpMoreSettingData.swift
//  Proto-UNDO
//
//  Created by Santu C on 07/11/15.
//  Copyright © 2015 Curly Brackets. All rights reserved.
//

import UIKit

class PumpMoreSettingData {
    
    var bIsNotJustNow:Bool = false
    var timeLeft:NSDate? = NSDate.init()
    var timeRight:NSDate? = NSDate.init()
    var timeBoth:NSDate? = NSDate.init()
    var bDisplayDescription:Bool = false
    
    var nLeftDurationHours:Int = 0
    var nLeftDurationMinutes:Int = 0
    
    var QuantityPump:Int = 0
    
    var bIsSelectedStar:Bool = false
    var bIsSelectedExclamation:Bool = false
    
    var strNoteText = ""
    var bottleImage : UIImage?
    
    
    var optAction:PumpActions! = .ActLeft
    
    enum PumpActions: Int {
        case ActLeft    = 1
        case ActRight   = 2
        case ActBoth   = 3
    }
    
    init () {
    }
}
