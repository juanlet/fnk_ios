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

class TopFundkersViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var serverFetchCampaignsUrl = Config.Global._serverUrl
    var fundkersTopRankingArray = [JSON]()
    let TOP_RANKING_NUMBER = 10;
    
    
    @IBOutlet weak var userRankLabel: UILabel!
    
    @IBOutlet weak var userProfilePicImageView: UIImageView!
    
    @IBOutlet weak var userTwitterUsernameLabel: UILabel!
    
    @IBOutlet weak var userContributionsLabel: UILabel!
    
    
    @IBOutlet weak var fundkersRankingTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTopFundkers()
    }
    
    func fetchTopFundkers(){
        //TODO: CHANGE CONTRIBUTORS-ID ON THE URL TO CUrrentUserUtil.firebaseId once the tab controller is fixed
        Alamofire.request(serverFetchCampaignsUrl+"/campaigns/get/contributors/ranking/contributor-id/802627618235355136/top/\(TOP_RANKING_NUMBER)", method: .get).validate().responseJSON { response in
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
        
        
        fundkersTopRankingArray = topFundkersDataJSON["top_ranking"].arrayValue
        
        let user = topFundkersDataJSON["user_rank"].object as? JSON
        if(user != nil){
            
            let userPosition = Int((user?["rank"].stringValue)!)
            
            if( userPosition! > 10){
                
                
                if let userRank =  user?["rank"].stringValue as? String{
                    userRankLabel.text = userRank
                }else{
                    print("user rank is null")
                }
                
                //cause campaign label
                if let userLogoUrlString = user?["profile_image_url"].stringValue as? String{
                    UIGeneralHelperFunctionsUtil.setImageViewAsync(userLogoUrlString, imageView: userProfilePicImageView)
                } else {
                    print("user profile pic url null")
                }
                
                //cause campaign label
                if let userTwitterUsername = user?["screen_name"].stringValue as? String{
                    userTwitterUsernameLabel.text = userTwitterUsername
                } else {
                    print("user twitter username null")
                }
                
                //cause campaign label
                if let userContributionsCount = user?["contributions_count"].stringValue as? String{
                    userContributionsLabel.text = userContributionsCount
                } else {
                    print("User contributions null")
                }
                
            }
        }
        
        //ESSENTIAL TO SHOW THE DATA ON TABLEVIEW, OTHERWISE IT DOESN'T SHOW ANYTHING SINCE THE FIRST TIME TABLE VIEW METHODS EXECUTE SPONSORS ARRAY DOESN'T HAVE ANY DATA
        print("Fundkers ranking AMMOUNT",fundkersTopRankingArray.count)
        DispatchQueue.main.async {
            self.fundkersRankingTableView.reloadData()
            
        }
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fundkersTopRankingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = fundkersRankingTableView.dequeueReusableCell(withIdentifier: "fundkerCell", for: indexPath) as! FundkerRankTableViewCell
        
        //setting card attributes
        let fundker = fundkersTopRankingArray[indexPath.row]
        
        if let fundkerRank =  fundker["rank"].stringValue as? String{
            cell.fundkerRankLabel.text = fundkerRank
        }else{
            print("fundker rank is null")
        }
        
        //cause campaign label
        if let fundkerLogoUrlString = fundker["profile_image_url"].stringValue as? String{
            UIGeneralHelperFunctionsUtil.setImageViewAsync(fundkerLogoUrlString, imageView: cell.fundkerProfilePicImageView)
        } else {
            print("Fundker profile pic url null")
        }
        
        //cause campaign label
        if let fundkerTwitterUsername = fundker["screen_name"].stringValue as? String{
            cell.fundkerTwitterUsernameLabel.text = fundkerTwitterUsername
        } else {
            print("Fundker twitter username null")
        }
        
        //cause campaign label
        if let fundkerContributionsCount = fundker["contributions_count"].stringValue as? String{
            cell.fundkerContributionsCountLabel.text = fundkerContributionsCount
        } else {
            print("Fundker contributions null")
        }
        
        return cell
        
    }
    
}
