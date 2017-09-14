//
//  MainViewControllerTableViewCell.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/13/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit

class MainViewControllerTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var foundationNamesLabel: UILabel!
    
  
    @IBOutlet weak var causeCampaignName: UILabel!

    
    @IBOutlet weak var daysToFinishLabel: UILabel!
    
    
    @IBOutlet weak var raisedOverTotalLabel: UILabel!
    
    
    @IBOutlet weak var percentageCompletedLabel: UILabel!
    
    @IBOutlet weak var goalProgresView: UIProgressView!
    
    @IBOutlet weak var causeCampaignImageView: UIImageView!
    
    //card used on
    @IBInspectable var cornerradius : CGFloat = 2
    
    @IBInspectable var shadowOffSetWidth : CGFloat = 0
    
    @IBInspectable var shadowOffSetHeight : CGFloat = 5
    
    @IBInspectable var shadowColor : UIColor = UIColor.black
    
    @IBInspectable var shadowOpacity : CGFloat = 0.5

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerradius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerradius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
    }


}
