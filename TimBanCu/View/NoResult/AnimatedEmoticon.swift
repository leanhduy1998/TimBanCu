//
//  AnimatedEmoticon.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/29/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import Lottie

final class AnimatedEmoticon:LOTAnimationView{
    
    private let emojiName = "empty_list"
    
    
    init(view:UIView) {
        super.init(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        self.setAnimation(named: emojiName)
        
        self.contentMode = .scaleAspectFill
        self.loopAnimation = true
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        self.heightAnchor.constraint(equalToConstant: 150).isActive = true
        self.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
