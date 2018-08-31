//
//  MajorAlerts.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/30/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class MajorAlerts{
    
    var viewcontroller:UIViewController!
    var addNewMajorAlert:AskForInputAlert!
    var addNewMajorCompletedAlert:InfoAlert!
    var majorAlreadyExistAlert:InfoAlert!
    
    
    var handler: ((UIAlertAction) -> Void)!
    
    init(viewcontroller:UIViewController){
        self.viewcontroller = viewcontroller
  
        setupAddNewMajorAlert()
        setupAddNewMajorCompletedAlert()
        setupMajorAlreadyExistAlert()
    }
    
    func showAddNewMajorAlert(handler: @escaping ((UIAlertAction) -> Void)){
        self.handler = handler
        addNewMajorAlert.show(viewcontroller: viewcontroller)
    }
    
    func showAddNewMajorCompletedAlert(){
        addNewMajorCompletedAlert.show(viewcontroller: viewcontroller)
    }
    func showMajorAlreadyExistAlert(){
        majorAlreadyExistAlert.show(viewcontroller: viewcontroller)
    }
    
    func showAlert(title:String,message:String){
        let alert = InfoAlert(title: title, message: message)
        alert.show(viewcontroller: viewcontroller)
    }
    
    private func setupMajorAlreadyExistAlert(){
        let title = "Khoa của bạn đã có trong danh sách!"
        let message = "Vui Lòng Chọn Khoa Trong Danh Sách Chúng Tôi Hoặc Thêm Khoa Mới"
        
        majorAlreadyExistAlert = InfoAlert(title: title, message: message)
    }
    
    private func setupAddNewMajorAlert(){
        let title = "Thêm Khoa Mới"
        addNewMajorAlert = AskForInputAlert(title: title, message: "", textFieldPlaceHolder: "Tên Khoa")
        addNewMajorAlert.addAction(actionTitle: "Thêm", handler: handler)
    }
    
    private func setupAddNewMajorCompletedAlert(){
        let title = "Khoa của bạn đã được thêm!"
        addNewMajorCompletedAlert = InfoAlert(title: title, message: "")
    }
}
