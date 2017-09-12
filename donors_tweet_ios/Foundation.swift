//
//  Foundation.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/12/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit

class Foundation{
    var twitterAccount:String
    var picPath:URL?
    var name:String
    
    init(_ twitterAccount:String, picPath:String, name:String){
        self.twitterAccount = twitterAccount
        self.picPath = URL(string:picPath)
        self.name = name
    }
}
