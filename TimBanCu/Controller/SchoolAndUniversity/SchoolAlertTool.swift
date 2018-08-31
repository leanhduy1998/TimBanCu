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

class SchoolAlertTool{
    
    var viewcontroller:UIViewController!
    var schoolType:SchoolType!
    
    
    var addNewSchoolAlert:AskForInputAlert!
    var addNewSchoolCompletedAlert:InfoAlert!
    var schoolAlreadyExistAlert:InfoAlert!
    
    
    var handler: ((UIAlertAction) -> Void)!
    
    init(viewcontroller:UIViewController, schoolType:SchoolType){
        self.viewcontroller = viewcontroller
        self.schoolType = schoolType
        
        setupAddNewSchoolAlert()
        setupAddNewSchoolCompletedAlert()
        setupSchoolAlreadyExistAlert()
    }
    
    func showAddNewSchoolAlert(handler: @escaping ((UIAlertAction) -> Void)){
        if(handler == nil){
            self.handler = handler
            addNewSchoolAlert.addAction(actionTitle: "Thêm", handler: handler)
        }
        else{
            self.handler = handler
        }
    
        addNewSchoolAlert.show(viewcontroller: viewcontroller)
    }
    
    func showAddNewSchoolCompletedAlert(){
        addNewSchoolCompletedAlert.show(viewcontroller: viewcontroller)
    }
    func showSchoolAlreadyExistAlert(){
        schoolAlreadyExistAlert.show(viewcontroller: viewcontroller)
    }
    
    func showAlert(title:String,message:String){
        let alert = InfoAlert(title: title, message: message)
        alert.show(viewcontroller: viewcontroller)
    }
    
    private func setupSchoolAlreadyExistAlert(){
        let title = "Trường của bạn đã có trong danh sách!"
        let message = "Vui Lòng Chọn Trường Trong Danh Sách Chúng Tôi Hoặc Thêm Trường Mới"

        schoolAlreadyExistAlert = InfoAlert(title: title, message: message)
    }
    
    private func setupAddNewSchoolAlert(){
        var title:String!
        
        switch(schoolType){
        case .Elementary:
            title = "Thêm Trường Tiểu Học Mới"
            break
        case .MiddleSchool:
            title = "Thêm Trường Trung Học Cơ Sở Mới"
            break
        case .HighSchool:
            title = "Thêm Trường Trung Học Phổ Thông Mới"
            break
        case .University:
            title = "Thêm Trường Đại Học Mới"
            break
        default:
            break
        }
        
        addNewSchoolAlert = AskForInputAlert(title: title, message: "", textFieldPlaceHolder: "Tên Trường")
    }
    
    private func setupAddNewSchoolCompletedAlert(){
        let title = "Trường của bạn đã được thêm!"
        addNewSchoolCompletedAlert = InfoAlert(title: title, message: "")
    }
}
