//
//  DetailClassAlerts.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/10/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension ClassNameViewController{
    func setupAlerts(){
        setupAddNewClassDetailAlert()
        setupAddNewClassDetailCompletedAlert()
    }
    
    private func setupAddNewClassDetailAlert(){
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
                
                let classModel = ClassName(classNumber: self.selectedClass, uid: AuthHelper.uid, schoolName: self.selectedSchool.name, className: className!.uppercased())

                DispatchQueue.main.async {
                    self.classesDetailRef.child(classModel.getObjectKey()).setValue(classModel.getObjectValueAsDic(), withCompletionBlock: { (err, ref) in
                        
                        DispatchQueue.main.async {
                            self.classDetails.append(classModel)
                            
                            self.searchClassDetails.append(classModel)
                            self.tableview.reloadData()
                            self.updateTableviewVisibilityBasedOnSearchResult()
                            self.present(self.addNewClassCompletedAlert, animated: true, completion: nil)
                            
                        }
                        
                    })
                }
            }
        }))
 
    }
    
    private func setupAddNewClassDetailCompletedAlert(){
        addNewClassCompletedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak addNewClassCompletedAlert] (_) in
            addNewClassCompletedAlert?.dismiss(animated: true, completion: nil)
        }))
    }
}
