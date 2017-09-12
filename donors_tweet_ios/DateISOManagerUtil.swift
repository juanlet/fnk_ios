//
//  DateISOManagerUtil.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/12/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit

class DateISOManagerUtil {
    
    //retuurns -1 if the date is null
    static func differenceOfDaysWithToday(_ isoDate:String)->Any {
    
        var dateNil = false
        var result:Int = -1

        
        if let dateString = isoDate as String?{
            
            if (!dateString.isEmpty && !dateNil) {
                result = 0
            } else {
                result = -1
            }
            
        }else{
            dateNil =  true
        }
    
        
        return result
    
    }
}
