//
//  UIHelperFunctionsUtil.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/20/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit


class UIGeneralHelperFunctionsUtil {
    
    

    static func setImageViewAsync(_ imageUrlString:String, imageView:UIImageView){
        
        let imageUrl:URL? = imageUrlString != "" ? URL(string: imageUrlString) : nil
        
        if (imageUrl != nil && self.verifyUrl(imageUrlString))  {

            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data!)
                }
            }
            
        }
        
        }
    
    //verifies if it's a valid url
    static func verifyUrl(_ urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
}
