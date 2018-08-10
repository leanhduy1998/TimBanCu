//
//  NoResultLabel.swift
//  TimBanCu
//
//  Created by Vy Le on 7/17/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class NoResultLabel: UILabel {
    
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = UIColor.darkGray
        self.textAlignment = .center
        self.numberOfLines = 3
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
