//
//  Contributor.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/12/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit

class Contributor{
    var profileImageUrl:URL?
    var followersCount:Int
    
    init(_ profileImageUrl:String,followersCount:String){
        self.profileImageUrl = URL(string:profileImageUrl)!
        self.followersCount = Int(followersCount)!
    }
}
