//
//  SelectSchoolTypeUIController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/28/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

final class SelectSchoolTypeUIController{
    var viewcontroller:UIViewController!
    
    init(viewcontroller:UIViewController){
        self.viewcontroller = viewcontroller
        viewcontroller.addNavigationBarShadow()
        viewcontroller.tabBarController?.tabBar.isHidden = false
    }
    
    func presentNextViewController() {
        viewcontroller.navigationController?.hero.isEnabled = true
        viewcontroller.navigationController?.hero.navigationAnimationType = .fade
        viewcontroller.performSegue(withIdentifier: "SelectQueryToSchoolSegue", sender: viewcontroller)
    }
    
    func setHeroId(selectedSchoolType:SchoolType){
        
    }
    
}
