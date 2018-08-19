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
        addNewClassAlert = AskForInputAlert.getAlert(title: "Thêm Lớp Mới", message: "", TFPlaceHolder: "Tên Lớp")
        
        let action = UIAlertAction(title: "Thêm", style: .default, handler: { [weak addNewClassAlert] (_) in
            let textField = addNewClassAlert?.textFields![0] // Force unwrapping because we know it exists.
            let className = textField?.text
            if(!(className?.isEmpty)!){
                
                let classDetail = ClassDetail(classNumber: self.classNumber, uid: CurrentUserHelper.getUid(), schoolName: self.school.name, className: className!.uppercased())
                self.selectedClassDetail = classDetail
                
                self.performSegue(withIdentifier: "ClassNameToClassYear", sender: self)
                
            }
        })
        
        addNewClassAlert.addAction(action)
 
    }
}
