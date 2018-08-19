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
        let title = "Trường của bạn đã có trong danh sách!"
        let message = "Vui Lòng Chọn Trường Trong Danh Sách Chúng Tôi Hoặc Thêm Trường Mới"

        schoolAlreadyExistAlert = InfoAlert.getAlert(title: title, message: message)
    }
    
    private func setupAddNewSchoolAlert(){
        addNewSchoolAlert = AskForInputAlert.getAlert(title: "", message: "", TFPlaceHolder: "Tên Trường")
        
        let action = UIAlertAction(title: "Thêm", style: .default, handler: { [weak addNewSchoolAlert] (_) in
            let textField = addNewSchoolAlert?.textFields![0] // Force unwrapping because we know it exists.
            let schoolName = textField?.text
            
            if(!(schoolName?.isEmpty)!){
                self.addSchoolToSchoolList(schoolName: schoolName!)
            }
        })
        
        addNewSchoolAlert.addAction(action)
    }
    
    private func setupAddNewSchoolCompletedAlert(){
        let title = "Trường của bạn đã được thêm!"
        addNewSchoolCompletedAlert = InfoAlert.getAlert(title: title, message: "")
    }
    
    
}
