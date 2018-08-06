//
//  ClassYearAlert.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/4/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension ClassYearViewController{
    func setupAlerts(){
        setupAddNewClassDetailCompletedAlert()
        setupClassAlreadyExistAlert()
    }
    
    private func setupAddNewClassDetailCompletedAlert(){
        addNewClassCompletedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak addNewClassCompletedAlert] (_) in
            addNewClassCompletedAlert?.dismiss(animated: true, completion: nil)
            
            self.performSegue(withIdentifier: "ClassYearToClassDetailSegue", sender: self)
        }))
    }
    
    private func setupClassAlreadyExistAlert(){
        classAlreadyExistAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak classAlreadyExistAlert] (_) in
            self.classAlreadyExistAlert.dismiss(animated: true, completion: nil)
        }))
    }
}
