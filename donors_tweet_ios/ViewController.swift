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

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var campaignRowsData  = ["Campaign 1","Campaign 2","Campaign 3'"]
    
    var serverFetchCampaignsUrl = "http://localhost:3000/api/campaigns/get/all"
    
    
    @IBOutlet weak var campaignTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        campaignTableView.delegate=self
        
        campaignTableView.dataSource=self
        getCampaignList()
    }
    
    
    func getCampaignList(){
    
        Alamofire.request(serverFetchCampaignsUrl, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print("JSON: \(json)")
                
                _ =  json["rows"].arrayValue.map({
                    
                
                    //create campaign cards here
                    
                    print($0["cause_description"].stringValue)
                
                
                })
                
            case .failure(let error):
                print(error)
            }
        }
    
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campaignRowsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = campaignTableView.dequeueReusableCell(withIdentifier: "CampaignCell")
    cell?.textLabel?.text = campaignRowsData[indexPath.row]
        
        return cell!
    }
    
    

}

