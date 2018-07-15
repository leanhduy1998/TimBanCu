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
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 2.5
        layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
        layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
    }
    
}
