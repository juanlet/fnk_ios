//
//  Sponsor.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/12/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit


class Sponsor {
    
    var id:String
    var twitterUsername:String
    var name:String
    var picUrl:URL
    var allTimeUsersReached:Int
    var adText:String
    var bannerUrl:URL?
    var ad:AdCampaign
    var video:Video
    
    init(_ id:String,twitterUsername:String,name:String,picUrl:String?,allTimeUsersReached:String,adText:String,bannerUrl:URL,ad:AdCampaign,video:Video) {
        // perform some initialization here
        
        self.id = id
        self.twitterUsername = twitterUsername
        self.name = name
        self.picUrl = URL(string:picUrl!)!
        self.allTimeUsersReached = Int(allTimeUsersReached)!
        self.adText = adText
        self.bannerUrl = bannerUrl
        self.ad = ad
        self.video = video
    }
    
}
