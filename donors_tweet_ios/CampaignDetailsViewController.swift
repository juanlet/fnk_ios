//
//  CampaignDetailsViewController.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 1/29/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class CampaignDetailsViewController: UIViewController {
    
    var serverFetchCampaignsUrl = Config.Global._serverUrl

    var causeCampaignId : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(causeCampaignId)
        
        fetchCauseCampaignData()
        
        
    }
    
    func fetchCauseCampaignData(){
        
        Alamofire.request(serverFetchCampaignsUrl+"/campaigns/get/\(causeCampaignId!)/user/\(CurrentUserUtil.firebaseId)/contributor/\(CurrentUserUtil.contributorUserId)", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                
                
                let campaignCauseDetailsJSON = JSON(campaignCausesData: data)
                
                 self.parseCampaignCauseDetailsResponse(campaignCauseDetailsJSON)
                
                
            case .failure(let error):
                print(error)
            }
        }

        
        
    }

    func parseCampaignCauseDetailsResponse(_ campaignCauseDetailsJSON:JSON){
        
        
        if let name = campaignCauseDetailsJSON["name"].string {
            //Now you got your value
            print("NAME",name)
            //set label
            
        }
    }

}
