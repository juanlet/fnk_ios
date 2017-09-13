//
//  CardView.swift
//  donors_tweet_ios
//
//  Created by Juan andrés Ferreyra on 9/12/17.
//  Copyright © 2017 shamanito. All rights reserved.
//

import UIKit

@IBDesignable class CauseCampaignCardView: UIView {

 //card used on
    @IBInspectable var cornerradius : CGFloat = 2
    
    @IBInspectable var shadowOffSetWidth : CGFloat = 0
    
    @IBInspectable var shadowOffSetHeight : CGFloat = 5
    
    @IBInspectable var shadowColor : UIColor = UIColor.black
 
    @IBInspectable var shadowOpacity : CGFloat = 0.5


    override func layoutSubviews() {
        layer.cornerRadius = cornerradius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerradius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
    }
}
