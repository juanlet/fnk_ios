//
//  UITableViewCell.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/20/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit

class  FoundationTableViewCell:UITableViewCell {
    

    @IBOutlet weak var foundationLogoImageView: UIImageView!
    
 
    
    
    @IBOutlet weak var foundationTwitterUsernameLabel: UILabel!
    
    @IBOutlet weak var foundationNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    


}
