//
//  ShimmeringLabel.swift
//  TimBanCu
//
//  Created by Vy Le on 8/18/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class ShimmeringLabel: UILabel {
    
    init(textColor: UIColor, view: UIView) {
        super.init(frame:  CGRect(x: 0, y: 100, width: view.frame.width, height: 100))
        self.text = "Tìm bạn cũ"
        self.font = UIFont(name: "FS-Playlist-Caps", size: 70)
        self.textColor = textColor
        self.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
