//
//  blackFilterBackground.swift
//  TimBanCu
//
//  Created by Vy Le on 10/7/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class BlackFilterBackground: UIView {
    
    private weak var viewcontroller: UIViewController!
    
    init(viewcontroller: UIViewController) {
        super.init(frame: .zero)
        self.viewcontroller = viewcontroller
        viewcontroller.view.addSubview(self)
        viewcontroller.view.sendSubview(toBack: self)
        
        setUpSelf()
        setSelfConstraints()
    }
    
    private func setSelfConstraints(){
        self.topAnchor.constraint(equalTo: viewcontroller.view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: viewcontroller.view.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: viewcontroller.view.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: viewcontroller.view.rightAnchor).isActive = true
        
    }
    
    private func setUpSelf() {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


