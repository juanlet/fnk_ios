//
//  SponsorsViewController.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/18/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class SponsorsViewController: UIViewController {
    
    var serverFetchCampaignsUrl = Config.Global._serverUrl


    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSponsors()
    }

    func fetchSponsors(){
        
        Alamofire.request(serverFetchCampaignsUrl+"/sponsors/get/all/", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                
                
                let sponsorsListDataJSON = JSON(sponsorsListData: data)
                
                self.parseSponsorsDataResponse(sponsorsListDataJSON)
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func parseSponsorsDataResponse(_ sponsorsListDataJSON:JSON){
        
//        {
//            rows: [
//            {
//            sponsor_id: "1",
//            twitter_username: "@audiArg",
//            name: "Audi",
//            pic_url: "http://www.hiclasscar.com/audi-logo.png",
//            all_time_users_reached: 400
//            },
//            {
//            sponsor_id: "2",
//            twitter_username: "@SamsungArg",
//            name: "Samsung",
//            pic_url: "https://pbs.twimg.com/profile_images/656495541908430848/K0LNjd7T_400x400.png",
//            all_time_users_reached: 550
//            },
//            {
//            sponsor_id: "3",
//            twitter_username: "@laserenisima",
//            name: "La serenisima",
//            pic_url: "https://pbs.twimg.com/profile_images/738018524610854912/vk5FzSyc.jpg",
//            all_time_users_reached: 220
//            },
//            {
//            sponsor_id: "47",
//            twitter_username: "Lane.OKon",
//            name: "Jeremy Abernathy",
//            pic_url: "http://lorempixel.com/640/480",
//            all_time_users_reached: 0
//            },
//            {
//            sponsor_id: "48",
//            twitter_username: "Alford.Grady97",
//            name: "Mrs. Candelario Rogahn",
//            pic_url: "http://lorempixel.com/640/480",
//            all_time_users_reached: 0
//            },
//            {
//            sponsor_id: "49",
//            twitter_username: "Major_Lebsack71",
//            name: "Mr. Hassan Harvey",
//            pic_url: "http://lorempixel.com/640/480",
//            all_time_users_reached: 0
//            },
//            {
//            sponsor_id: "50",
//            twitter_username: "Leonard_Gaylord",
//            name: "Max Pfeffer",
//            pic_url: "http://lorempixel.com/640/480",
//            all_time_users_reached: 0
//            },
//            {
//            sponsor_id: "51",
//            twitter_username: "Samantha79",
//            name: "Twila Kerluke",
//            pic_url: "https://s3.amazonaws.com/uifaces/faces/twitter/normanbox/128.jpg",
//            all_time_users_reached: 0
//            },
//            {
//            sponsor_id: "55",
//            twitter_username: "Virgie65",
//            name: "Verla Harber",
//            pic_url: "https://s3.amazonaws.com/uifaces/faces/twitter/alagoon/128.jpg",
//            all_time_users_reached: 0
//            },
//            {
//            sponsor_id: "56",
//            twitter_username: "Marilyne_Batz98",
//            name: "Harmon Cassin",
//            pic_url: "https://s3.amazonaws.com/uifaces/faces/twitter/kushsolitary/128.jpg",
//            all_time_users_reached: 0
//            },
//            {
//            sponsor_id: "57",
//            twitter_username: "Kody_Schmeler28",
//            name: "Araceli Upton",
//            pic_url: "https://s3.amazonaws.com/uifaces/faces/twitter/mugukamil/128.jpg",
//            all_time_users_reached: 0
//            },
//            {
//            sponsor_id: "58",
//            twitter_username: "Brandi47",
//            name: "Giovani Gutmann PhD",
//            pic_url: "https://s3.amazonaws.com/uifaces/faces/twitter/andyisonline/128.jpg",
//            all_time_users_reached: 0
//            },
//            {
//            sponsor_id: "59",
//            twitter_username: "Patience36",
//            name: "Zelma Hammes IV",
//            pic_url: "https://s3.amazonaws.com/uifaces/faces/twitter/baumann_alex/128.jpg",
//            all_time_users_reached: 0
//            },
//            {
//            sponsor_id: "60",
//            twitter_username: "Cora.Tremblay",
//            name: "Raheem Fisher",
//            pic_url: "https://s3.amazonaws.com/uifaces/faces/twitter/vitorleal/128.jpg",
//            all_time_users_reached: 0
//            }
//            ]
//        }
        
    }

}
