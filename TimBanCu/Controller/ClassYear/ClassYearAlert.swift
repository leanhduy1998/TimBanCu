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
        
        if(classDetail != nil){
            addNewClassCompletedAlert = UIAlertController(title: "Lớp của bạn đã được thêm!", message: "", preferredStyle: .alert)
            classAlreadyExistAlert = UIAlertController(title: "Lớp của bạn đã có trong danh sách!", message: "Vui Lòng Chọn Lớp Trong Danh Sách Chúng Tôi Hoặc Thêm Lớp Mới", preferredStyle: .alert)
        }
        else if(majorDetail != nil){
            addNewClassCompletedAlert = UIAlertController(title: "Khoa của bạn đã được thêm!", message: "", preferredStyle: .alert)
            classAlreadyExistAlert = UIAlertController(title: "Khoa của bạn đã có trong danh sách!", message: "Vui Lòng Chọn Khoa Trong Danh Sách Chúng Tôi Hoặc Thêm Khoa Mới", preferredStyle: .alert)
        }
        
        setupAddNewClassDetailCompletedAlert()
        setupClassAlreadyExistAlert()
    }
    
    private func setupAddNewClassDetailCompletedAlert(){
        addNewClassCompletedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak addNewClassCompletedAlert] (_) in
            addNewClassCompletedAlert?.dismiss(animated: true, completion: nil)
            
            self.performSegue(withIdentifier: "ClassYearToClassDetailSegue", sender: self)
        }))
    }
    
    private func setupClassAlreadyExistAlert(){
        classAlreadyExistAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak classAlreadyExistAlert] (_) in
            self.classAlreadyExistAlert.dismiss(animated: true, completion: nil)
        }))
    }
}
