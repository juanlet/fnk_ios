//
//  CurrentUserUtil.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/12/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit


class CurrentUserUtil {
    
    static var username: String = ""
    
    static var twitterPicUrl:URL! = URL(string:"https://www.apple.com")
    
    static var twitterFollowersCount:Int = 0
    
    static var facebookFollowersCount:Int = 0
    
    static var firebaseId:String = ""
    
    static var twitterId:String = ""
    
    static var facebookId:String = ""
    
    static var contributorUserId:String = ""
    
    static var millisecondsTillNextClick:Int = 0
    
    static var twitterUserName:String = ""
    
    static var twitterAccessToken:String = ""
    
    static var twitterAccessTokenSecret:String = ""
    
    static var twitterDisplayName:String = ""
    
    static func getTotalFollowersAllNetworks() -> Int{
        //TODO:FACEBOOK FOLLOWERS STILL NOT BEING CALCULATED ON THE BACKEND, SO IT's 0 FOR NOW
        return twitterFollowersCount + facebookFollowersCount
    }
    
}
