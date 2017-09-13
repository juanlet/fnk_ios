//
//  ViewController.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 1/28/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase


class MainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var campaignRowsData  = [CauseCampaign]()
    
    var serverFetchCampaignsUrl = Config.Global._serverUrl
    
    
    
    @IBOutlet weak var campaignTableView: UITableView!

    
    //show navigation controller bar
    
    var facebookID = "", twitterID = "",firebaseID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //hide bar from navigation controller
        
        setToolbar()

        campaignTableView.delegate=self
        
        campaignTableView.dataSource=self
        
        campaignTableView.separatorColor = UIColor(white: 0.95, alpha: 1)
        
        recoverUserDefaults()
        
        getCampaignList()
        
        //print(facebookID, twitterID, firebaseID)
        
    }
    
    
    func setToolbar(){
        //hide bar from navigation controller
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.purple
        
        
        
    }
    
    func getCampaignList(){
    
        Alamofire.request(serverFetchCampaignsUrl+"/campaigns/get/all/user/\(twitterID)/firebase/\(firebaseID)/cat/0", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let data):

                
                let campaignCausesJSON = JSON(campaignCausesData: data)
                
                self.parseCampaignCausesListResponse(campaignCausesJSON)
                
                //alternative thread operation
                //TODO:PUT IT IN ANOTHER THREAD
                OperationQueue.addOperation({
                    self.campaignTableView.reloadData()
                })
                
            case .failure(let error):
                print(error)
            }
        }
    
    }
    
    func parseCampaignCausesListResponse(_ campaignCausesJSON:JSON){
        
        if let activeCampaignCount = campaignCausesJSON["active_campaigns_count"].string {
            //Now you got your value
            print("TOTAL_ACTIVE_CAMPAIGNS",activeCampaignCount)
            CampaignsGlobalDataManagerUtil.campaignTotalCount = Int(activeCampaignCount)!
        }
        
        if let contributorUserId = campaignCausesJSON["contributor_user_id"].string {
            //Now you got your value
            print("CONTRIBUTOR_USER_ID",contributorUserId)
            CurrentUserUtil.contributorUserId = contributorUserId
        }
        
        if let userTwitterFollowersQty = campaignCausesJSON["user_twitter_followers_qty"].int {
            //Now you got your value
            print("USER_TWITTER_FOLLOWERS_QTY",userTwitterFollowersQty)
            CurrentUserUtil.twitterFollowersCount = Int(userTwitterFollowersQty)
        }
        
        //Parsing campaigns object array
        
        if let causesCampObjectArray = campaignCausesJSON["camp_array"].arrayObject {
            //Now you got your value
            //print(causesCampObjectArray)
            
            for causeCampaign:AnyObject in causesCampObjectArray as [AnyObject]{
                parseCampaign(causeCampaign)
            }
        }

    }
    //TODO:CHANGE TO DATATAPE OBJECT
    func parseCampaign(_ causeCampaign:AnyObject){
        
        let causeCampaignObject: CauseCampaign = CauseCampaign();
        
        if let campaignEndingDate = causeCampaign["campaign_ending_date"] as? Date{
            //Now you got your value
            let formatter = ISO8601DateFormatter()
            print(formatter.string(from: campaignEndingDate))
            causeCampaignObject.campaignEndingDate = formatter.string(from: campaignEndingDate)

        }
        
        campaignRowsData.append(causeCampaignObject)
        
//        "campaign_ending_date" = "2019-07-08T00:00:00-03:00";
//        "campaign_id" = 60;
//        "cause_description" = "descripcion causa imp1";
//        "contributors_qty" = 1;
//        "created_at" = "2017-08-25T01:24:32.681072-03:00";
//        "currency_symbol" = "$";
//        "current_contributions" = 0;
//        foundations = "<null>";
//        goal = 30000;
//        "goal_percentage_achieved" = 0;
//        hashtag = "#imp1";
//        name = imp1;
//        "pic_url" = "http://lorempixel.com/640/480";
//        "remaining_ammount_to_goal" = 0;
//        "tweet_id" = 900936910494810112;
//        "went_inactive_date" = "<null>";
    
    }
    

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campaignRowsData.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
       let cell = campaignTableView.dequeueReusableCell(withIdentifier: "CampaignCell") as! CauseCampaignCardView
        
    //setting card attributes
        
        let campaignCause:CauseCampaign = campaignRowsData[indexPath.row]
        cell.daysToFinishLabel!.text = campaignCause.campaignEndingDate
        
        return cell
    }
    
    
    func recoverUserDefaults(){
        if let fbID = UserDefaults.standard.object(forKey: Config.Global._facebookIdUserDefaults) as? String {
            facebookID = fbID
        }else{
            print("FACEBOOK ID IS NULL")
        }
        
        
        
        if let twtID = UserDefaults.standard.object(forKey: Config.Global._twitterIdUserDefaults) as? String{
            twitterID = twtID
        }else{
            print("TWITTER ID IS NULL")
        }
        
        
        if  let firID = UserDefaults.standard.object(forKey: Config.Global._firebaseIdUserDefaults) as? String{
            firebaseID = firID
        }else{
            print("TWITTER ID IS NULL")
        }
        
        return
    }
    
    

}

