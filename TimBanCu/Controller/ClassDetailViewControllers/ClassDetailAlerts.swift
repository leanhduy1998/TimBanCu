//
//  DetailClassAlerts.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/10/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension ClassDetailViewController{
    func setupAlerts(){
        setupAddNewSchoolAlert()
        setupAddNewSchoolCompletedAlert()
    }
    
    private func setupAddNewSchoolAlert(){
        addNewClassAlert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { [weak addNewClassAlert] (_) in
            addNewClassAlert?.dismiss(animated: true, completion: nil)
        }))
        
        addNewClassAlert.addTextField { (textField) in
            textField.placeholder = "Tên Lớp"
        }
        
        addNewClassAlert.addAction(UIAlertAction(title: "Thêm", style: .default, handler: { [weak addNewClassAlert] (_) in
            let textField = addNewClassAlert?.textFields![0] // Force unwrapping because we know it exists.
            let className = textField?.text
            if(!(className?.isEmpty)!){
                
                let classModel = Class(className: className!, uid: AuthHelper.uid, schoolName: self.selectedSchool.name)

                DispatchQueue.main.async {
                    self.classesDetailRef.child(className!).setValue(classModel.getObjectValueAsDic(), withCompletionBlock: { (err, ref) in
                        
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
        addNewClassCompletedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak addNewClassCompletedAlert] (_) in
            addNewClassCompletedAlert?.dismiss(animated: true, completion: nil)
        }))
    }
}
