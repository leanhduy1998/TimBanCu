//
//  ClassYearAlert.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/4/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension ClassYearViewController{
    func setupAlerts(){
        
        
        
        
        
        
        
        
        setupAddNewClassDetailCompletedAlert()
        setupClassAlreadyExistAlert()
    }
    
    private func setupAddNewClassCompleteAlert(){
        var title:String!
        var message = ""
        
        if(classProtocol is ClassDetail){
            title = "Lớp của bạn đã được thêm!"
        }
        else{
            title = "Khoa của bạn đã được thêm!"
        }
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: { [weak addNewClassCompletedAlert] (_) in
            addNewClassCompletedAlert?.dismiss(animated: true, completion: nil)
            
            self.performSegue(withIdentifier: "ClassYearToClassDetailSegue", sender: self)
        })
        
        addNewClassCompletedAlert = InfoAlert.getAlert(title: title, message: message, action: action)
    }
    private func setupClassAlreadyExistAlert(){
        var title:String!
        var message:String!
        
        if(classProtocol is ClassDetail){
            title = "Lớp của bạn đã có trong danh sách!"
            message = "Vui Lòng Chọn Lớp Trong Danh Sách Chúng Tôi Hoặc Thêm Lớp Mới"
        }
        else{
            title = "Khoa của bạn đã có trong danh sách!"
            message = "Vui Lòng Chọn Khoa Trong Danh Sách Chúng Tôi Hoặc Thêm Khoa Mới"
        }
        
        classAlreadyExistAlert = InfoAlert.getAlert(title: title, message: message)
    }
    
    private func setupAddNewClassDetailCompletedAlert(){
        
    }
    
}
