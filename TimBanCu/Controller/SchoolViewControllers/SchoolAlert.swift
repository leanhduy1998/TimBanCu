//
//  SchoolAlert.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/10/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

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
        
        addNewSchoolAlert.addAction(UIAlertAction(title: "Thêm", style: .default, handler: { [weak addNewSchoolAlert] (_) in
            let textField = addNewSchoolAlert?.textFields![0] // Force unwrapping because we know it exists.
            let schoolName = textField?.text
            if(!(schoolName?.isEmpty)!){
                let school = School(name: schoolName!, address: "?", type: self.selectedSchoolType, uid: AuthHelper.uid)
               
                DispatchQueue.main.async {
                    self.schoolsRef.child(schoolName!).setValue(school.getObjectValueAsDic(), withCompletionBlock: { (err, ref) in
                        
                        DispatchQueue.main.async {
                            self.schoolViewModels.append(school)
                            
                            self.searchSchoolModels.append(school)
                            self.tableview.reloadData()
                            self.updateTableviewVisibilityBasedOnSearchResult()
                            self.present(self.addNewSchoolCompletedAlert, animated: true, completion: nil)
                            
                        }
                        
                    })
                }
            }
        }))
    }
    
    private func setupAddNewSchoolCompletedAlert(){
        addNewSchoolCompletedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak addNewSchoolCompletedAlert] (_) in
            addNewSchoolCompletedAlert?.dismiss(animated: true, completion: nil)
        }))
    }
    
    
}
