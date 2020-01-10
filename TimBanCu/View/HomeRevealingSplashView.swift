//
//  HomeRevealingSplashView.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 3/3/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import RevealingSplashView
import UIKit

class HomeRevealingSplashView:RevealingSplashView{
    init(){
        let iconImage = #imageLiteral(resourceName: "Logo")
        let iconInitialSize = CGSize(width: 140, height: 140)
        let backgroundColor = UIColor(red:255/255, green:158/255, blue: 0, alpha:1.0)
        
        super.init(iconImage: iconImage, iconInitialSize: iconInitialSize, backgroundColor: backgroundColor)
        
        animationType = SplashAnimationType.popAndZoomOut
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
