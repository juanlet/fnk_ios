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

class FoundationsViewController: UIViewController {

    var serverFetchCampaignsUrl = Config.Global._serverUrl

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
    


}
