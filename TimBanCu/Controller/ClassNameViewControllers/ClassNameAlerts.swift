//
//  DetailClassAlerts.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/10/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class ClassNameAlerts{
    
    private weak var viewcontroller:UIViewController!
    private var addNewClassAlert:AskForInputAlert!
    private var addNewClassCompleteAlert:InfoAlert!
    private var classAlreadyExistAlert:InfoAlert!
    private var cancelAddingClassAlert:ConfirmationAlert!
    private var addNewClassHandler: (String) -> ()
    
    init(viewcontroller:UIViewController,addNewClassHandler: @escaping (String) -> ()){
        self.viewcontroller = viewcontroller
        self.addNewClassHandler = addNewClassHandler
        setupAddNewClassNameAlert()
        setupClassAlreadyExistAlert()
        setupAddNewClassNameCompletedAlert()
        setupCancelAddingClassAlert()
    }
    
    func showAddNewClassNameAlert(){
        addNewClassAlert.show(viewcontroller: viewcontroller)
    }
    func showAddNewClassNameComplete(){
        addNewClassCompleteAlert.show(viewcontroller: viewcontroller)
    }
    
    func showClassAlreadyExistAlert(){
        classAlreadyExistAlert.show(viewcontroller: viewcontroller)
    }
    
    func showCancelAddingClassAlert(){
        cancelAddingClassAlert.showAlert(viewcontroller: viewcontroller)
    }
    
    func showAlert(title:String,message:String){
        let alert = InfoAlert(title: title, message: message)
        alert.show(viewcontroller: viewcontroller)
    }
        
    private func setupAddNewClassNameAlert(){
        addNewClassAlert = AskForInputAlert(title: "Thêm Lớp Mới", message: "", textFieldPlaceHolder: "Tên Lớp")
        addNewClassAlert.addAction(actionTitle: "Thêm") { (_) in
            self.addNewClassHandler(self.addNewClassAlert.getTextFieldInput())
        }
    }
    
    private func setupClassAlreadyExistAlert(){
        let title = "Lớp của bạn đã có trong danh sách!"
        let message = "Vui Lòng Chọn Lớp Trong Danh Sách Chúng Tôi Hoặc Thêm Lớp Mới"
        
        classAlreadyExistAlert = InfoAlert(title: title, message: message)
    }
    
    private func setupAddNewClassNameCompletedAlert(){
        let title = "Thêm Lớp Thành Công!"
        let message = "Bước Tiếp Theo: Chọn Năm Học Của Bạn"
        addNewClassCompleteAlert = InfoAlert(title: title, message: message)
    }
    
    private func setupCancelAddingClassAlert(){
        cancelAddingClassAlert = ConfirmationAlert(title: "Bạn Có Muốn Huỷ Thêm Lớp?", message: "Lớp sẽ không được lưu vào hệ thống của chúng tôi") {
            DispatchQueue.main.async { [weak self] in
                self!.viewcontroller.navigationController!.popViewController(animated: true)
                
            }
        }
    }
}
