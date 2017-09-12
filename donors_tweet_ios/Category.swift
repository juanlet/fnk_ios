//
//  Category.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/12/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit

class Category{
    
    var categoryId:String;
    var descriptionEs:String;
    var acronymEs:String;
    
    init(_ categoryId:String,descriptionEs:String,acronymEs:String){
        self.categoryId = categoryId
        self.descriptionEs = descriptionEs
        self.acronymEs = acronymEs
    }
    
}
