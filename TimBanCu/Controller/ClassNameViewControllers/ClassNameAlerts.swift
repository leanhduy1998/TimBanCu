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
                
                let classDetail = ClassDetail(classNumber: self.classNumber, uid: CurrentUserHelper.getUid(), schoolName: self.school.name, className: className!.uppercased())
                self.selectedClassDetail = classDetail
                
                self.performSegue(withIdentifier: "ClassNameToClassYear", sender: self)
                
                /*
                DispatchQueue.main.async {
                    classModel.writeClassDetailToDatabase(completionHandler: { (err, ref) in
                        DispatchQueue.main.async {
                            if(err == nil){
                                self.classDetails.append(classModel)
                                self.tableview.reloadData()
                                self.updateTableviewVisibilityBasedOnSearchResult()
                                self.present(self.addNewClassCompletedAlert, animated: true, completion: nil)
                                
                                
                            }
                            else{
                                if(err?.localizedDescription == "Permission denied") {
                                    self.present(self.classAlreadyExistAlert, animated: true, completion: nil)
                                }
                            }
                        }
                    })
                }*/
            }
        }))
 
    }
}
