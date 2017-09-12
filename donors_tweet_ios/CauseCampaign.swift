//
//  Campaign.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/12/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit

class CauseCampaign{
    
    var description:String
    var goal:Float
    var id:String
    var currentContributions:Float
    var totalUniqueUsersReached:Int
    var state:String
    var remainingAmmountToGoal:Float
    var goalPercentageAchieved:Float
    var goalPercentageAchievedNotRounded:Float
    //TODO: change to ISO date type, search stackoverflow
    var campaignEndingDate:String
    var hashtag:String
    var currencySymbol:String
    var picUrl:URL?
    var remainingDaysToFinish:Int
    var contributorsQty:Int
    
    init(_ description:String,goal:String,id:String,currentContributions:String,totalUniqueUsersReached:String,state:String,remainingAmmountToGoal:String,goalPercentageAchieved:String,goalPercentageAchievedNotRounded:String,campaignEndingDate:String,hashtag:String,currency:String,picUrl:String,remainingDaysToFinish:String,contributorsQty:String){
        
        self.description = description
        self.goal = Float(goal)!
        self.id = id
        self.currentContributions = Float(currentContributions)!
        self.totalUniqueUsersReached = Int(totalUniqueUsersReached)!
        self.state = state
        self.remainingAmmountToGoal = Float(remainingAmmountToGoal)!
        self.goalPercentageAchieved = Float(goalPercentageAchieved)!
        self.goalPercentageAchievedNotRounded = Float(goalPercentageAchievedNotRounded)!
        self.campaignEndingDate = campaignEndingDate
        self.hashtag = hashtag
        self.currencySymbol = currency
        self.picUrl = URL(string: picUrl)
        self.remainingDaysToFinish = Int(remainingDaysToFinish)!
        self.contributorsQty = Int(contributorsQty)!
        
        
    }

}
