//
//  SchoolAlert.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/10/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import AWSDynamoDB

extension SchoolViewController{
    func setupAlerts(){
        setupAddNewSchoolAlert()
        setupAddNewSchoolCompletedAlert()
    }
    
    private func setupAddNewSchoolAlert(){
        addNewSchoolAlert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { [weak addNewSchoolAlert] (_) in
            addNewSchoolAlert?.dismiss(animated: true, completion: nil)
        }))
        
        addNewSchoolAlert.addTextField { (textField) in
            textField.placeholder = "Tên Trường"
        }
    }
    
    private func setupAddNewSchoolCompletedAlert(){
        addNewSchoolAlert.addAction(UIAlertAction(title: "Thêm", style: .default, handler: { [weak addNewSchoolAlert] (_) in
            let textField = addNewSchoolAlert?.textFields![0] // Force unwrapping because we know it exists.
            let schoolName = textField?.text
            if(!(schoolName?.isEmpty)!){
                let newSchool = School()
                newSchool?._type = self.selectedScanStr
                newSchool?._address = "?"
                newSchool?._school = schoolName
                self.dynamoDBObjectMapper.save(newSchool!).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
                    if let error = task.error as? NSError {
                        print("The request failed. Error: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.present(self.addNewSchoolCompletedAlert, animated: true, completion: nil)
                            
                            
                            let newSchoolVM = SchoolViewModel(name: (newSchool?._school)!, address: (newSchool?._address)!, type: (newSchool?._type)!)
                            
                            self.schoolViewModels.append(newSchoolVM)
                            self.searchSchoolVMs.append(newSchoolVM)
                            
                            self.setTableviewVisibilityBasedOnSearchResult()
                            
                            self.tableview.reloadData()
                        }
                    }
                    return nil
                })
            }
        }))
        
        
        
        addNewSchoolCompletedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak addNewSchoolAlert] (_) in
            addNewSchoolAlert?.dismiss(animated: true, completion: nil)
        }))
    }
    
    
}
