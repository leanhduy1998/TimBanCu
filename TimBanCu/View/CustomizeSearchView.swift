//
//  CustomizeSearchView.swift
//  TimBanCu
//
//  Created by Vy Le on 8/14/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class CustomizeSearchView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 6
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        layer.borderWidth = 1
    }
    
}
