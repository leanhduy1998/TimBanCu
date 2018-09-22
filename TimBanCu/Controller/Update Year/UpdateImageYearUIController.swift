//
//  UpdateImageYearUIController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/14/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class UpdateImageYearUIController{
    fileprivate var alerts:UpdateImageYearAlerts!
    fileprivate weak var viewcontroller:UIViewController!
    fileprivate var keyboardHelper:KeyboardHelper!
    
    init(viewcontroller:UpdateImageYearViewController){
        self.viewcontroller = viewcontroller
        
        setupAlerts()
        
        keyboardHelper = KeyboardHelper(viewcontroller: viewcontroller, shiftViewWhenShow: true, keyboardWillShowClosure: nil, keyboardWillHideClosure: nil)
    }
    
    func showYearOutOfLowerBoundAlert(){
        alerts.showYearOutOfLowerBoundAlert()
    }
    
    func showYearIsInTheFutureAlert(){
        alerts.showYearIsInTheFutureAlert()
    }
}

// Alerts
extension UpdateImageYearUIController{
    func setupAlerts(){
        alerts = UpdateImageYearAlerts(viewcontroller: viewcontroller)
    }
}
