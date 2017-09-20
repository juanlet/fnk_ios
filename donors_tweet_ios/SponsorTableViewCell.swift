//
//  SponsorTableViewCell.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/20/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit

class  SponsorTableViewCell:UITableViewCell {
    
    
    @IBOutlet weak var sponsorLogoImageView: UIImageView!
    
    
    @IBOutlet weak var sponsorTwitterUserNameLabel: UILabel!
    
    @IBOutlet weak var sponsorNameLabel: UILabel!
    
    @IBOutlet weak var allTimeUsersReachedLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}

