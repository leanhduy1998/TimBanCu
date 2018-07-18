//
//  NoResultButton.swift
//  TimBanCu
//
//  Created by Vy Le on 7/17/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class NoResultButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        self.setAttributedTitle(NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold), NSAttributedStringKey.foregroundColor: UIColor(red: 255/255, green: 158/255, blue: 0/255, alpha: 1.0)]), for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
