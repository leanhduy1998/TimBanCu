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
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 0.0, height: 2)
        layer.shadowColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 0.5).cgColor
    }
    
}
