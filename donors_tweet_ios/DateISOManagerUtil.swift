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
    static func differenceOfDaysWithToday(_ isoDateString:String)->Int {
    
        
        //convert to ISO DATE
        let isoformatter = ISO8601DateFormatter.init()

        guard let finishDate = isoformatter.date(from: isoDateString) else{
            return -1
        }


        let calendar = Calendar.current
        
        let numberOfDaysLeft = calendar.dateComponents([.day], from: Date(), to: finishDate)

        let result =  numberOfDaysLeft.day!
        
     
    
        return result
    
    }
}
