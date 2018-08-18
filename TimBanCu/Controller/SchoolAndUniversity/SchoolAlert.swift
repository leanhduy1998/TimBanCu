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
        
        setupSchoolAlreadyExistAlert()
    }
    
    private func setupSchoolAlreadyExistAlert(){
        schoolAlreadyExistAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak schoolAlreadyExistAlert] (_) in
            self.schoolAlreadyExistAlert.dismiss(animated: true, completion: nil)
        }))
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
                let school = School(name: schoolName!, address: "?", type: self.selectedSchoolType, uid: CurrentUserHelper.getUid())
                
                self.addSchoolToDatabase(school: school, completionHandler: { (err, ref) in
                    DispatchQueue.main.async {
                        if(err == nil){
                            self.addSchoolToLocal(school: school)
                            self.present(self.addNewSchoolCompletedAlert, animated: true, completion: nil)
                        }
                        else{
                            if(err?.localizedDescription == "Permission denied") {
                                self.present(self.schoolAlreadyExistAlert, animated: true, completion: nil)
                            }
                        }
                    }
                    
                })
            }
        }))
    }
    
    func addSchoolToDatabase(school:School,completionHandler: @escaping (_ err:Error?, _ ref:DatabaseReference)->Void){
        Database.database().reference().child("schools").child(school.name).setValue(school.getObjectValueAsDic(), withCompletionBlock: completionHandler)
    }
    
    func addSchoolToLocal(school:School){
        schoolModels.append(school)
        searchSchoolModels.append(school)
        tableview.reloadData()
        updateTableviewVisibilityBasedOnSearchResult()
    }
    
    private func setupAddNewSchoolCompletedAlert(){
        addNewSchoolCompletedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak addNewSchoolCompletedAlert] (_) in
            addNewSchoolCompletedAlert?.dismiss(animated: true, completion: nil)
        }))
    }
    
    
}
