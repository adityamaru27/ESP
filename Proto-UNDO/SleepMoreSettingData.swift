//
//  SleeoMoreSettingData.swift
//  SleepMore
//
//  Created by Lee Xiaoxiao on 9/30/15.
//  Copyright © 2015 Lee Xiaoxiao. All rights reserved.
//

import Foundation
import UIKit

class SleepMoreSettingData {
    var bIsNotJustNow:Bool = false
    var timeFellAsleep:NSDate? =  NSDate.init()
    var timeWokeUp:NSDate? =  NSDate.init()
    var timeDuration:String? =  ""
    
    var nDurationHours:Int = 0
    var nDurationMinutes:Int = 0
    
    var bIsSelectedStar:Bool = false
    var bIsSelectedExclamation:Bool = false
    var bIsSelectedParent:Bool = false
    
    var strNoteText = ""
    var sleepImage : UIImage?
    
}
