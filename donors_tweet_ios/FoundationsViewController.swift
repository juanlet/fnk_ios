//
//  FoundationsViewController.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/18/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class FoundationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var serverFetchCampaignsUrl = Config.Global._serverUrl
    var foundationsArray = [JSON]()
    
    @IBOutlet weak var foundationsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFoundations()
    }
    
    func fetchFoundations(){
        
        Alamofire.request(serverFetchCampaignsUrl+"/foundations/get/all/", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                
                
                let foundationsListDataJSON = JSON(foundationsListData: data)
                
                self.parseFoundationsDataResponse(foundationsListDataJSON)
                
                
            case .failure(let error):
                print(error)
            }
        }
       
    }
    
    func parseFoundationsDataResponse(_ foundationsListDataJSON:JSON){
        
        
        foundationsArray = foundationsListDataJSON["rows"].arrayValue
        
        //ESSENTIAL TO SHOW THE DATA ON TABLEVIEW, OTHERWISE IT DOESN'T SHOW ANYTHING SINCE THE FIRST TIME TABLE VIEW METHODS EXECUTE FOUNDATIONS ARRAY DOESN'T HAVE ANY DATA
        print("FOUNDATIONS_AMMOUNT",foundationsArray.count)
        DispatchQueue.main.async {
            self.foundationsTableView.reloadData()
            
        }
        
//        {
//            rows: [
//            {
//            foundation_id: "1",
//            twitter_username: "@RedSolidariaOK",
//            name: "Red Solidaria",
//            pic_path: "http://www.biopappel.com/sites/bio.o5411197210.v3.s1.chi.boa.io/files/media/logo_fundacion_teleton.jpg"
//            },
//            {
//            foundation_id: "2",
//            twitter_username: "@fundacionespectro",
//            name: "Espectro",
//            pic_path: "https://lafundaciondejabad.org.ar/wp-content/uploads/2016/09/LogoFDJ.jpg"
//            },
//            {
//            foundation_id: "6",
//            twitter_username: "Odessa69",
//            name: "Johann Price",
//            pic_path: "https://s3.amazonaws.com/uifaces/faces/twitter/xripunov/128.jpg"
//            }
//            ]
//        }
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = foundationsTableView.dequeueReusableCell(withIdentifier: "foundationCell", for: indexPath) as! FoundationTableViewCell
        
        //setting card attributes
        let foundation = foundationsArray[indexPath.row]
            
        //cause campaign label
        if let foundationLogoUrlString = foundation["pic_path"].stringValue as? String{
            UIGeneralHelperFunctionsUtil.setImageViewAsync(foundationLogoUrlString, imageView: cell.foundationLogoImageView)
        } else {
            print("Foundation logo url null")
        }
        
        //cause campaign label
        if let foundationName = foundation["name"].stringValue as? String{
            cell.foundationNameLabel.text = foundationName
        } else {
            print("Foundation name null")
        }
        
        //cause campaign label
        if let foundationTwitterUsername = foundation["twitter_username"].stringValue as? String{
            cell.foundationTwitterUsernameLabel.text = foundationTwitterUsername
        } else {
            print("Foundation twitter username null")
        }
        
        
        return cell
        
    }
    


}
