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
import FBSDKLoginKit
import TwitterKit



class MainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var campaignRowsData  = [CauseCampaign]()
    var categoriesArray = [Any]()
    
    @IBOutlet weak internal var totalActiveCampaignsLabel: UILabel!
    
    var serverFetchCampaignsUrl = Config.Global._serverUrl
    
    @IBAction func onLogoutButtonClick(_ sender: Any) {
        
        if (Auth.auth().currentUser != nil){
            //user is signed in
            
            do{
                
                try? Auth.auth().signOut()
                logOutUserFromAllSocialNetworks()
                redirectUserToLogin()
                
            }catch let error as Error {
                print(error.localizedDescription)
            }
            
            print("user logged out correctly")
        }else{
            //user is not signed in, is this neccesary or the listener is going to take care of it??
            redirectUserToLogin()
        }
    }
    
    @IBOutlet weak var campaignTableView: UITableView!
    
    //show navigation controller bar
    
    var facebookID = "", twitterID = "",firebaseID = ""
    
    let causeCampaignDetailsSegueIdentifier = "causeCampaignDetailSegue"

   
    
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
        
        getCategoriesList()

        
        //print(facebookID, twitterID, firebaseID)
        
    }
    
    private func getCategoriesList(){
        
        Alamofire.request(serverFetchCampaignsUrl+"/campaigns/get/categories/all", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                
                
                let categoriesListJSON = JSON(data)
                
                self.parseCategories(categoriesListJSON)
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    private func parseCategories(_ categoriesListJSON:JSON){
        
        categoriesArray = categoriesListJSON["data"].arrayValue
        
//        go over the categories
        categoriesArray.map({
            //TODO LUCAS: create bubbles with categories
            print($0)
            
        })
        
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

                
                let campaignCausesJSON = JSON(data)
                
                self.parseCampaignCausesListResponse(campaignCausesJSON)
                
                //alternative thread operation
            
                
                DispatchQueue.main.async {
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
            
            //TODO FILL LABEL WITH total active campaigns
            
            totalActiveCampaignsLabel.text = "ACTIVE CAMPAIGNS: \(activeCampaignCount)"
            
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
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == causeCampaignDetailsSegueIdentifier,
            let destination = segue.destination as? CampaignDetailsViewController,
            let campaignCellIndex = campaignTableView.indexPathForSelectedRow?.row
        {
            destination.causeCampaignId = campaignRowsData[campaignCellIndex].id
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
       let cell = campaignTableView.dequeueReusableCell(withIdentifier: "campaignCell", for: indexPath) as! MainViewControllerTableViewCell
        
    //setting card attributes
        let campaignCause:CauseCampaign = campaignRowsData[indexPath.row]
        
        //cause campaign label
        if let name = campaignCause.name as? String{
                cell.causeCampaignName.text = name
        } else {
            print("Campaign name null")
        }
        
        //image view
        if let imageUrlString = campaignCause.picUrl as? String{
           //donwload images async
         
                
            UIGeneralHelperFunctionsUtil.setImageViewAsync(imageUrlString, imageView: cell.causeCampaignImageView)
            
            
        } else {
            print("Image path null")
        }
        
        //goal percentage label
        if let percentageAchieved = campaignCause.goalPercentageAchieved as? Float{
            cell.percentageCompletedLabel.text = String(describing: percentageAchieved)
        }else{
            print("Goal Percentage achieved null")
        }
        
        
        //days left label
        let daysLeft = DateISOManagerUtil.differenceOfDaysWithToday(campaignCause.campaignEndingDate)
        
        if(daysLeft == -1){
        print("Incorrect Date or campaign with no ending date")
        cell.daysToFinishLabel.text = ""
        }else{
            
        cell.daysToFinishLabel.text = "\(String(describing: daysLeft)) días restantes"
        
        }
        
        
        //raised over total label
        let currentContributions = String(campaignCause.currentContributions)
        let goal = String(campaignCause.goal)
        let currencySymbol = campaignCause.currencySymbol
        
        cell.raisedOverTotalLabel.text = "\(currencySymbol) \(currentContributions) alcanzado de \(currencySymbol) \(goal)"
       
        cell.goalProgresView.setProgress(campaignCause.goalPercentageAchieved, animated: true)

        //Foundation names label
        
        var foundationNamesString = ""
        
        for foundation in campaignCause.foundations {
            foundationNamesString += foundation.name
        }
        
        cell.foundationNamesLabel.text = foundationNamesString
        
        return cell
    }
    
    
    func recoverUserDefaults(){
        if let fbID = UserDefaults.standard.object(forKey: Config.Global._facebookIdUserDefaultsKey) as? String {
            facebookID = fbID
        }else{
            print("FACEBOOK ID IS NULL")
        }
        
        
        
        if let twtID = UserDefaults.standard.object(forKey: Config.Global._twitterIdUserDefaultsKey) as? String{
            twitterID = twtID
             CurrentUserUtil.twitterId = twitterID
        }else{
            print("TWITTER ID IS NULL")
        }
        
        
        if  let firID = UserDefaults.standard.object(forKey: Config.Global._firebaseIdUserDefaultsKey) as? String{
            firebaseID = firID
             CurrentUserUtil.firebaseId = firebaseID
        }else{
            print("TWITTER ID IS NULL")
        }
        
        return
    }
    
    private func logOutUserFromAllSocialNetworks(){
        
        //logout user out of Facebook
        FBSDKAccessToken.setCurrent(nil)
        //logout user out of twitter
        let twitterSessionStore = Twitter.sharedInstance().sessionStore
        twitterSessionStore.reload()
        
        for case let session as TWTRSession in twitterSessionStore.existingUserSessions()
        {
            twitterSessionStore.logOutUserID(session.userID)
        }

        
    }
    
    private func redirectUserToLogin(){
        //user is logged in, redirect to main View
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let authScreenViewController = storyboard.instantiateViewController(withIdentifier: "AuthScreenViewController") as! AuthScreenViewController
        self.navigationController?.pushViewController(authScreenViewController, animated: true)
    }
    

}

