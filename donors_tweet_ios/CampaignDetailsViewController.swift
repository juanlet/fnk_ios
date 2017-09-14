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
    
    
    @IBOutlet weak var contributorsQtyLabel: UILabel!
    
    @IBOutlet weak var totalUsersReachedLabel: UILabel!
    
    @IBOutlet weak var totalRaisedLabel: UILabel!
    
    @IBOutlet weak var causeCampaignNameLabel: UILabel!
    
    @IBOutlet weak var goalLabel: UILabel!
    
    @IBOutlet weak var goalPercentageAchievedLabel: UILabel!
    
    
    
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
        
        
        let campaignCauseDetails = campaignCauseDetailsJSON["data"]
        
        if let name = campaignCauseDetails["name"].string {
            //set label
            causeCampaignNameLabel.text = name
            
        }
        
        if let totalContributors = campaignCauseDetails["contributors_qty"].string{
            contributorsQtyLabel.text = totalContributors
        }
        
        if let totalUniqueUsersReached = campaignCauseDetails["total_unique_users_reached"].string{
            totalUsersReachedLabel.text = totalUniqueUsersReached
        }
        
        if let currencySymbol = campaignCauseDetails["currency_symbol"].string{
          
             if let totalRaised = campaignCauseDetails["current_contributions"].string{
             
                totalRaisedLabel.text = "\(currencySymbol) \(totalRaised)"
                
            }
            
            if let goal = campaignCauseDetails["goal"].string{
                
                goalLabel.text = "\(currencySymbol) \(goal)"
            }

        }
        
        if let goalPercentageAchieved = campaignCauseDetails["goal_percentage_achieved"].string{
            
            goalPercentageAchievedLabel.text = "%\(goalPercentageAchieved)"
        }
        
        
    }

}
