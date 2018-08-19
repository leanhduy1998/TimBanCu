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
        let title = "Khoa của bạn đã có trong danh sách!"
        let message = "Vui Lòng Chọn Khoa Trong Danh Sách Chúng Tôi Hoặc Thêm Khoa Mới"

        majorAlreadyExistAlert = InfoAlert.getAlert(title: title, message: message)
    }
    
    private func setupAddNewMajorAlert(){
        addNewMajorAlert = AskForInputAlert.getAlert(title: "Thêm Khoa Mới", message: "", TFPlaceHolder: "Tên Khoa")
        let action = UIAlertAction(title: "Thêm", style: .default, handler: { [weak addNewMajorAlert] (_) in
            let textField = addNewMajorAlert?.textFields![0] // Force unwrapping because we know it exists.
            let majorName = textField?.text
            if(!(majorName?.isEmpty)!){
                let major = MajorDetail(uid: CurrentUserHelper.getUid(), schoolName: self.school.name, majorName: majorName!)
                
                self.selectedMajor = major
                
                self.performSegue(withIdentifier: "MajorToClassYearSegue", sender: self)
            }
        })
        addNewMajorAlert.addAction(action)
    }
    
    private func setupAddNewMajorCompletedAlert(){
        let title = "Trường của bạn đã được thêm!"
        let message = ""
        
        addNewMajorCompletedAlert = InfoAlert.getAlert(title: title, message: message)
    }
    
    
}
