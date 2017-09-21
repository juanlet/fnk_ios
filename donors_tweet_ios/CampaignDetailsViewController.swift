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
    
    var sponsorId:String? = nil
    
    var sponsorAdId:String? = nil
    
    
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
    

    @IBOutlet weak var timeLeftTillNextClickLabel: UILabel!
    
    
    
    @IBAction func onClickShareButton(_ sender: Any){
        
           //propagates the campaign to social networks currently associated to the user
           shareCauseCampaignToSocialNetworks()
     
    
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
                
                
                let campaignCauseDetailsJSON = JSON(data)
                
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
                
                
                let sponsorAdJSON = JSON(data)
                
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
        
         sponsorId = adCampaignData["sponsor_id"].stringValue
        
        
        
        let allTimeUsersReached = adCampaignData["all_time_users_reached"].int
        
        
        
        let sponsorPicUrlString = adCampaignData["pic_url"].stringValue
        
             UIGeneralHelperFunctionsUtil.setImageViewAsync(sponsorPicUrlString, imageView: sponsorLogoImageView)
        
         //ad
        
        let ad = adCampaignData["ad"]
        
        sponsorAdId = ad["sponsor_ad_id"].stringValue
        
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
                
                
                let lastContributorsJSON = JSON(data)
                
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
            
            
            print(contributorFollowersCount,contributorProfileImageUrlString)
            
            
            
        })
        
    }
    
    private func shareCauseCampaignToSocialNetworks(){
       
        let params = buildParamsForPostingToSocialNetworks()
        
        Alamofire.request(serverFetchCampaignsUrl+"/api/twitter/post", method: .post, parameters: params, encoding: URLEncoding.httpBody).responseJSON { response in
            
            if let socialNetworkResponsedata = response.data {
                let socialNetworksPostResponseJSON = JSON(socialNetworkResponsedata)

                self.parseSocialNetworksPostResponse(socialNetworksPostResponseJSON)
            }
        }
    }
    
    private func buildParamsForPostingToSocialNetworks()->[String: Any]{
        
        //TODO:Change mail to a variable when twitter white list out app
        let params: [String: Any] = ["access_token": CurrentUserUtil.twitterAccessToken,
                      "access_token_secret": CurrentUserUtil.twitterAccessTokenSecret,
                      "campaign_id": self.causeCampaignId,
                      "sponsor_ad_id":self.sponsorAdId,
                      "sponsor_id": self.sponsorId,
                      "twitter_display_name":CurrentUserUtil.twitterDisplayName,
                      "twitter_user_id":CurrentUserUtil.twitterId,
                      "twitter_username":CurrentUserUtil.twitterUserName,
                      "twitter_email":"a@a",
                      "twitter_photo_url":CurrentUserUtil.twitterPicUrl!,
                      "firebase_user_id":CurrentUserUtil.firebaseId,
                      "user_twitter_followers_qty": CurrentUserUtil.twitterFollowersCount
           ]
    
        return params
    }
    
    private func parseSocialNetworksPostResponse(_ socialNetworksPostResponseJSON:JSON){
        
        
       // let responseCode = socialNetworksPostResponseJSON["code"].stringValue
        
    }

}
