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
    
    //last contributors section
    
    @IBOutlet weak var lastContributorsView: UIView!
    
    
    @IBAction func onClickShareButton(_ sender: Any) {
        
        print("Hola")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(causeCampaignId)
        
        fetchCauseCampaignData()
        
        fetchSponsorAd()
        
        fetchLastContributorsData()
        
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
        
        
         //sponsor data
        
        let sponsorTwitterUsername =  adCampaignData["twitter_username"].stringValue
        
        
        sponsorTwitterNameLabel.text = sponsorTwitterUsername != "" ?  sponsorTwitterUsername : ""
        
        let sponsorName = adCampaignData["name"].stringValue
        
        sponsorNameLabel.text = sponsorName != "" ? sponsorName : ""
        
        let sponsor_id = adCampaignData["sponsor_id"].stringValue
        
        
        
        let allTimeUsersReached = adCampaignData["all_time_users_reached"].int
        
        
        
        let sponsorPicUrlString = adCampaignData["pic_url"].stringValue
        
             UIGeneralHelperFunctionsUtil.setImageViewAsync(sponsorPicUrlString, imageView: sponsorLogoImageView)
        
         //ad
        
        let ad = adCampaignData["ad"]
        
        let sponsorAdId = ad["sponsor_ad_id"].stringValue
        
        let bannerUrlString = ad["banner_url"].stringValue
        
        let bannerUrl: URL? = bannerUrlString != "" ? URL(string: bannerUrlString) : nil
        
        
        let videoUrlString = ad["video_url"].stringValue
        let videoUrl: URL? = videoUrlString != "" ? URL(string: videoUrlString ) : nil
        let tweetTextContent = ad["text"].stringValue
        
        
        adTextLabel.text = tweetTextContent
        
        
         //youtube video data
        
         let video = adCampaignData["youtube_video"]
        
         let videoTitle = video["title"].stringValue
        
         adVideoNameLabel.text = videoTitle
        
         let videoDescription = video["description"].stringValue
        
         adVideoDescriptionLabel.text = videoDescription
        
         let videoThumbnailUrlString = video["thumbnail"]["url"].stringValue
        
         UIGeneralHelperFunctionsUtil.setImageViewAsync(videoThumbnailUrlString, imageView: adVideoThumbnailImageView)
        
         let videoWidth = video["thumbnail"]["width"].int
         let videoHeight = video["thumbnail"]["height"].int
        
        
        
         


        
    }
    
    func fetchLastContributorsData(){
        
        Alamofire.request(serverFetchCampaignsUrl+"/campaigns/get/contributors/\(causeCampaignId!)", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                
                
                let lastContributorsJSON = JSON(lastContributorsData: data)
                
                self.parseLastContributorsDataResponse(lastContributorsJSON)
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func parseLastContributorsDataResponse(_ contributorsData:JSON){
        
        let totalContributorsCampaign = contributorsData["total_contributors_campaign"]
        
        contributorsData["contributors"].arrayValue.map({
            
            let contributorProfileImageUrlString = $0["profile_image_url"].stringValue
            
            let contributorProfileImageUrl:URL? =  contributorProfileImageUrlString != "" ? URL(string:contributorProfileImageUrlString) : nil
            
            let contributorFollowersCount = $0["followers_count"].stringValue
            
            //create label and bubble
            
            let lastContributorLabel = UILabel()
            
            lastContributorLabel.text = "\(contributorFollowersCount) alcance"
            
            lastContributorsView.addSubview(lastContributorLabel)
            
//            NSLayoutConstraint.activate([
//                lastContributorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//                lastContributorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//                lastContributorLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
//                lastContributorLabel.heightAnchor.constraint(equalToConstant: 50)])
            
            print(contributorFollowersCount,contributorProfileImageUrlString)
            
            
            
        })
        
    }

}
