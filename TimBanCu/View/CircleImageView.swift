//
//  CircleImageView.swift
//  TimBanCu
//
//  Created by Vy Le on 7/24/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = self.frame.size.height / 2
    }
    
}
