//
//  TopFunersViewController.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/18/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class TopFundkersViewController: UIViewController {
    
    var serverFetchCampaignsUrl = Config.Global._serverUrl

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTopFundkers()
    }

    func fetchTopFundkers(){
        
        Alamofire.request(serverFetchCampaignsUrl+"/campaigns/get/contributors/ranking/contributor-id/\(CurrentUserUtil.firebaseId)/top/10", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                
                
                let topFundkersDataJSON = JSON(topFundkersData: data)
                
                self.parseTopFundkersDataResponse(topFundkersDataJSON)
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func parseTopFundkersDataResponse(_ topFundkersDataJSON:JSON){
        
//        {
//            top_ranking: [
//            {
//            contributor_user_id: 10,
//            contributions_count: 12,
//            rank: 1,
//            profile_image_url: "http://pbs.twimg.com/profile_images/880447018753241088/10wc94vM_normal.jpg",
//            screen_name: "miguespanto"
//            },
//            {
//            contributor_user_id: 1,
//            contributions_count: 4,
//            rank: 2,
//            profile_image_url: "http://wallpaper-gallery.net/images/image/image-13.jpg",
//            screen_name: "@marianieves"
//            },
//            {
//            contributor_user_id: 2,
//            contributions_count: 2,
//            rank: 3,
//            profile_image_url: "https://www.asus.com/lifestyle/zenfone/wp-content/uploads/2015/09/generic_user_male.jpg",
//            screen_name: "@mariodiaz"
//            },
//            {
//            contributor_user_id: 3,
//            contributions_count: 2,
//            rank: 4,
//            profile_image_url: "http://www.northwesternflipside.com/wp-content/uploads/2013/08/generic-woman.jpg",
//            screen_name: "@flaviorodri"
//            },
//            {
//            contributor_user_id: 8,
//            contributions_count: 1,
//            rank: 5,
//            profile_image_url: "profileimage",
//            screen_name: "@nam"
//            },
//            {
//            contributor_user_id: 6,
//            contributions_count: 1,
//            rank: 6,
//            profile_image_url: "http://jurislink.com/admin/images/d09e1ae5fb3b934e958c45f9265cfc1c.jpeg",
//            screen_name: "@cletuspistolero"
//            },
//            {
//            contributor_user_id: 5,
//            contributions_count: 1,
//            rank: 7,
//            profile_image_url: "http://www.northwesternflipside.com/wp-content/uploads/2013/08/generic-woman.jpg",
//            screen_name: "@edgardocarrera"
//            },
//            {
//            contributor_user_id: 4,
//            contributions_count: 1,
//            rank: 8,
//            profile_image_url: "https://www.jamf.com/jamf-nation/img/default-avatars/generic-user.png",
//            screen_name: "@flaviadiaz"
//            }
//            ],
//            user_rank: null
//        }
        
    }
}
