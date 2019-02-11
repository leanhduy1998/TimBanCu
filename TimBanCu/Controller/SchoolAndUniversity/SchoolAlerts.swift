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

class SchoolAlerts{
    
    private weak var viewcontroller:UIViewController!
    private var schoolType:EducationLevel!

    private var addNewSchoolCompletedAlert:InfoAlert!
    private var schoolAlreadyExistAlert:InfoAlert!
    
    
    init(viewcontroller:SchoolViewController){
        self.viewcontroller = viewcontroller
        self.schoolType = viewcontroller.educationLevel
        
        setupAddNewSchoolCompletedAlert()
        setupSchoolAlreadyExistAlert()
    }
    

    func showAddNewSchoolCompletedAlert(){
        addNewSchoolCompletedAlert.show(viewcontroller: viewcontroller)
    }
    func showSchoolAlreadyExistAlert(){
        schoolAlreadyExistAlert.show(viewcontroller: viewcontroller)
    }
    
    func showAlert(title:String,message:String){
        let alert = InfoAlert(title: title, message: message, alertType: .Error)
        alert.show(viewcontroller: viewcontroller)
    }
    
    private func setupSchoolAlreadyExistAlert(){
        let title = "Trường của bạn đã có trong danh sách!"
        let message = "Vui Lòng Chọn Trường Trong Danh Sách Chúng Tôi Hoặc Thêm Trường Mới"

        schoolAlreadyExistAlert = InfoAlert(title: title, message: message, alertType: .AlreadyExist)
    }
        
    private func setupAddNewSchoolCompletedAlert(){
        let title = "Thêm Trường Thành Công!"
        addNewSchoolCompletedAlert = InfoAlert(title: title, message: "Bước Tiếp Theo: Chọn Lớp của bạn", alertType: .Success)
    }
}
