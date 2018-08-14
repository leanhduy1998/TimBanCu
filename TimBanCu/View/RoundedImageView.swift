//
//  RoundedImageView.swift
//  TimBanCu
//
//  Created by Vy Le on 8/13/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {
    
    override func awakeFromNib() {
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
}
