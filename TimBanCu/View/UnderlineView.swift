//
//  UnderlineView.swift
//  TimBanCu
//
//  Created by Vy Le on 8/19/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class UnderlineView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0).withAlphaComponent(0.5)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints(searchTF:UITextField,viewcontroller:UIViewController){
        self.topAnchor.constraint(equalTo: searchTF.bottomAnchor, constant: 8).isActive = true
        self.leftAnchor.constraint(equalTo: viewcontroller.view.leftAnchor, constant: 20).isActive = true
        self.rightAnchor.constraint(equalTo: viewcontroller.view.rightAnchor, constant: -20).isActive = true
        self.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
