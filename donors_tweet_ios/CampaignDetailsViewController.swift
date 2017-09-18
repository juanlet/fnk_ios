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
    
    //sponsor ad section
    
    @IBOutlet weak var sponsorNameLabel: UILabel!
    
    @IBOutlet weak var sponsorTwitterNameLabel: UILabel!
    
    @IBOutlet weak var sponsorLogoImageView: UIImageView!
    
    @IBOutlet weak var adTextLabel: UILabel!
    
    
    @IBOutlet weak var adVideoThumbnailImageView: UIImageView!
    
    @IBOutlet weak var adVideoNameLabel: UILabel!
    
    @IBOutlet weak var adVideoDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(causeCampaignId)
        
        fetchCauseCampaignData()
        
        fetchSponsorAd()
        
        
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
    

    func parseCampaignCauseDetailsResponse(_ campaignCauseDetailsJSON: JSON){
        
        
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
    
    
    func fetchSponsorAd(){
        
        //
        Alamofire.request(serverFetchCampaignsUrl+"/sponsors/get/sponsor/followers/\(CurrentUserUtil.getTotalFollowersAllNetworks())", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                
                
                let sponsorAdJSON = JSON(sponsorAdData: data)
                
                self.parseSponsorAdResponse(sponsorAdJSON)
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func parseSponsorAdResponse(_ sponsorAdJSON: JSON){
        
        let adCampaignData = sponsorAdJSON["data"]
        
        print(adCampaignData)
        
        
         //sponsor data
        
        let sponsorTwitterUsername =  adCampaignData["twitter_username"].stringValue
        
        
        sponsorTwitterNameLabel.text = sponsorTwitterUsername != "" ?  sponsorTwitterUsername : ""
        
        let sponsorName = adCampaignData["name"].stringValue
        sponsorNameLabel.text = sponsorName != "" ? sponsorName : ""
        
        let sponsor_id = adCampaignData["sponsor_id"].stringValue
        
        let allTimeUsersReached = adCampaignData["all_time_users_reached"].int
        
        let sponsorPicUrl = URL(string: adCampaignData["pic_url"].stringValue)
            
    
        
         //ad
        
         let ad = adCampaignData["ad"]
        
         let sponsorAdId = ad["sponsor_ad_id"].stringValue
        
        let bannerUrlString = ad["banner_url"].stringValue
        
        let bannerUrl: URL? = bannerUrlString != "" ? URL(string: bannerUrlString) : nil
        
        
        let videoUrlString = ad["video_url"].stringValue
        let videoUrl: URL? = videoUrlString != "" ? URL(string: videoUrlString ) : nil
        let tweetTextContent = ad["text"].stringValue
        
        
         //youtube video data
        
         let video = adCampaignData["youtube_video"]
        
         let videoTitle = video["title"].stringValue
         let videoDescription = video["description"].stringValue
         let videoThumbnailUrlString = video["thumbnail"]["url"].stringValue
         let videoThumbnailUrl:URL = videoThumbnailUrlString != "" ? URL(string: videoThumbnailUrlString) : nil
         let videoWidth = video["thumbnail"]["width"].int
         let videoHeight = video["thumbnail"]["height"].int
        
        
         
         


        
    }

}
