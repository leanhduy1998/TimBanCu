//
//  MajorUIController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/30/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class MajorUIController{
    var viewcontroller:UIViewController!
    var alerts :MajorAlerts!
    
    init(viewcontroller:UIViewController){
        self.viewcontroller = viewcontroller
        alerts = MajorAlerts(viewcontroller: viewcontroller)
    }
    
    func showAddNewMajorAlert(completionHandler: @escaping (_ userInput:String)->Void){
        let handler: (UIAlertAction) -> Void = { _ in
            completionHandler(self.alerts.addNewMajorAlert.getTextFieldInput())
        }
        
        alerts.showAddNewMajorAlert(handler: handler)
    }
}
