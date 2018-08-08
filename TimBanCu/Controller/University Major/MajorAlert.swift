//
//  MajorAlert.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/5/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

extension MajorViewController{
    func setupAlerts(){
        setupAddNewMajorAlert()
        setupAddNewMajorCompletedAlert()
        
        setupMajorAlreadyExistAlert()
    }
    
    private func setupMajorAlreadyExistAlert(){
        majorAlreadyExistAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak majorAlreadyExistAlert] (_) in
            self.majorAlreadyExistAlert.dismiss(animated: true, completion: nil)
        }))
    }
    
    private func setupAddNewMajorAlert(){
        addNewMajorAlert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { [weak addNewMajorAlert] (_) in
            addNewMajorAlert?.dismiss(animated: true, completion: nil)
        }))
        
        addNewMajorAlert.addTextField { (textField) in
            textField.placeholder = "Tên Khoa"
        }
        
        addNewMajorAlert.addAction(UIAlertAction(title: "Thêm", style: .default, handler: { [weak addNewMajorAlert] (_) in
            let textField = addNewMajorAlert?.textFields![0] // Force unwrapping because we know it exists.
            let majorName = textField?.text
            if(!(majorName?.isEmpty)!){
                let major = MajorDetail(uid: UserHelper.uid, schoolName: self.school.name, majorName: majorName!)
                
                self.selectedMajor = major
                
                self.performSegue(withIdentifier: "MajorToClassYearSegue", sender: self)
                
                /*DispatchQueue.main.async {
                    
                    let schoolsRef = Database.database().reference().child("schools")
                    schoolsRef.child(self.school.name!).setValue(major.getObjectValueAsDic(), withCompletionBlock: { (err, ref) in
                        
                        if(err == nil){
                            DispatchQueue.main.async {
                                self.majors.append(major)
                                
                                self.searchMajors.append(major)
                                self.tableview.reloadData()
                                self.updateTableviewVisibilityBasedOnSearchResult()
                                self.present(self.addNewMajorCompletedAlert, animated: true, completion: nil)
                                
                            }
                        }
                        else{
                            if(err?.localizedDescription == "Permission denied") {
                                self.present(self.majorAlreadyExistAlert, animated: true, completion: nil)
                                
                            }
                        }
                    })
                }*/
            }
        }))
    }
    
    private func setupAddNewMajorCompletedAlert(){
        addNewMajorCompletedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak addNewMajorCompletedAlert] (_) in
            addNewMajorCompletedAlert?.dismiss(animated: true, completion: nil)
        }))
    }
    
    
}
