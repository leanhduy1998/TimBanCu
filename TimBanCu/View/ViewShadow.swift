//
//  ViewShadow.swift
//  TimBanCu
//
//  Created by Vy Le on 7/14/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//
import UIKit

class ViewShadow: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        layer.shadowOpacity = 1
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0.0, height: 3)
        layer.shadowColor = UIColor(red: 214/255, green: 211/255, blue: 231/255, alpha: 1.0).cgColor
        //layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
    }
    
}
