//
//  Campaign.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/12/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit

class CauseCampaign{
    
    var description:String = ""
    var goal:Float = 0.0
    var id:String = ""
    var currentContributions:Float = 0.0
    var totalUniqueUsersReached:Int = 0
    var state:String = ""
    var remainingAmmountToGoal:Float = 0.0
    var goalPercentageAchieved:Float = 0.0
    var goalPercentageAchievedNotRounded:Float = 0.0
    //TODO: change to ISO date type, search stackoverflow
    var campaignEndingDate:String = ""
    var hashtag:String = ""
    var currencySymbol:String = ""
    var picUrl:URL? = URL(string: "")
    var remainingDaysToFinish:Int = 0
    var contributorsQty:Int = 0
    
//    init(_ description:String,goal:String,id:String,currentContributions:String,totalUniqueUsersReached:String,state:String,remainingAmmountToGoal:String,goalPercentageAchieved:String,goalPercentageAchievedNotRounded:String,campaignEndingDate:String,hashtag:String,currency:String,picUrl:String,remainingDaysToFinish:String,contributorsQty:String){
//        
//        self.description = description
//        self.goal = Float(goal)!
//        self.id = id
//        self.currentContributions = Float(currentContributions)!
//        self.totalUniqueUsersReached = Int(totalUniqueUsersReached)!
//        self.state = state
//        self.remainingAmmountToGoal = Float(remainingAmmountToGoal)!
//        self.goalPercentageAchieved = Float(goalPercentageAchieved)!
//        self.goalPercentageAchievedNotRounded = Float(goalPercentageAchievedNotRounded)!
//        self.campaignEndingDate = campaignEndingDate
//        self.hashtag = hashtag
//        self.currencySymbol = currency
//        self.picUrl = URL(string: picUrl)
//        self.remainingDaysToFinish = Int(remainingDaysToFinish)!
//        self.contributorsQty = Int(contributorsQty)!
//        
//        
//    }

}
