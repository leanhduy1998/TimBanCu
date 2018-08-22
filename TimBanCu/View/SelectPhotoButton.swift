//
//  SelectPhotoButton.swift
//  TimBanCu
//
//  Created by Vy Le on 8/22/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class SelectPhotoButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setAttributedTitle(NSAttributedString(string: "Select\n Photos", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold), NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.numberOfLines = 2
        self.titleLabel?.textAlignment = .center
        self.layer.cornerRadius = 60
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(red: 196/255, green: 122/255, blue: 0, alpha: 1.0)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setConstraints(yearLabel: UIView, image: UIView) {
        let imageHeight = (image.bounds.height / 2) + 40
        
        self.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.heightAnchor.constraint(equalToConstant: 120).isActive = true
        self.centerXAnchor.constraint(equalTo: yearLabel.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: yearLabel.centerYAnchor, constant: -imageHeight).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
