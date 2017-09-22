//
//  Config.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/12/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit

class Config: NSObject {

    struct Global {
        //url of the server base path
        static let _serverUrl = "http://localhost:3000/api"
        //tag to store facebook id in user defaults
        static let _facebookIdUserDefaultsKey = "FACEBOOK_ID"
        //tag to store twitter id in user defaults
        static let _twitterIdUserDefaultsKey = "TWITTER_ID"
        //tag to store firebase id in user defaults
        static let _firebaseIdUserDefaultsKey = "FIREBASE_ID"
        
        static let _twitterAccessTokenUserDefaultsKey =  "TWITTER_ACCESS_TOKEN"
        
        static let _twitterAccessTokenSecretUserDefaultsKey = "TWITTER_ACCESS_TOKEN_SECRET"

    }
    
}
