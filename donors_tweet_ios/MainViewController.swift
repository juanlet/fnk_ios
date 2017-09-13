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
            
                
                DispatchQueue.global().async {
                    self.campaignTableView.reloadData()
 
                }
                
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
      
          campaignCausesJSON["camp_array"].arrayValue.map({
            
            let campaignCause:JSON = $0
            
             parseCampaign(campaignCause)
          })
            
        


    }
    //TODO:CHANGE TO DATATAPE OBJECT
    func parseCampaign(_ causeCampaign:JSON){
        
        let causeCampaignObject: CauseCampaign = CauseCampaign();
        
        causeCampaignObject.description = causeCampaign["cause_description"].stringValue
        

        causeCampaignObject.id = causeCampaign["campaign_id"].stringValue

        
        if let contributorsQty = causeCampaign["contributors_qty"].int{
            causeCampaignObject.contributorsQty = contributorsQty
            
        }
        
        causeCampaignObject.currencySymbol = causeCampaign["currency_symbol"].stringValue
        
        if let currentContributions = causeCampaign["current_contributions"].float{
            causeCampaignObject.currentContributions = currentContributions
            
        }
        
        if let goal = causeCampaign["goal"].float {
            causeCampaignObject.goal = goal
        }
        
        if let goalPercentageAchieved = causeCampaign["goal_percentage_achieved"].float{
            causeCampaignObject.goalPercentageAchieved = causeCampaign["goal_percentage_achieved"].float!
        }
   
        causeCampaignObject.hashtag = causeCampaign["hashtag"].stringValue

        causeCampaignObject.name = causeCampaign["name"].stringValue
        
        if let remainingAmmountToGoal = causeCampaign["remaining_ammount_to_goal"].float{
            causeCampaignObject.remainingAmmountToGoal = remainingAmmountToGoal
        }
        
        if let picUrl =  causeCampaign["pic_url"].stringValue as? String {
            causeCampaignObject.picUrl = picUrl
        }
        
        if let campaignStartingDate = causeCampaign["created_at"].string{
            causeCampaignObject.campaignStartingDate = campaignStartingDate
        }
        
        if let campaignEndingDate = causeCampaign["campaign_ending_date"].string{
            causeCampaignObject.campaignEndingDate = campaignEndingDate
            
        }
        
        
        var foundationsArray = [Foundation]()

        causeCampaign["foundations"].arrayValue.map({
            
            let id = $0["foundation_id"].stringValue
            let twitterUsername = $0["twitter_username"].stringValue
            let picPath = $0["pic_path"].stringValue
            let name = $0["name"].stringValue
            
            let foundation:Foundation = Foundation(id,twitterAccount: twitterUsername,picPath: picPath,name: name)
            
            foundationsArray.append(foundation)
        })

        
        causeCampaignObject.foundations = foundationsArray
        
        
        campaignRowsData.append(causeCampaignObject)
        
//        foundations = "<null>";

//innecesario
//        SACAR DE LA REQUEST INICIAL???
//        "went_inactive_date" = "<null>";
//        "tweet_id" = 900936910494810112;

    
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

