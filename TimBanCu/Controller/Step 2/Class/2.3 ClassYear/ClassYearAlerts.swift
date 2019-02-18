//
//  ClassYearAlert.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/4/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class ClassYearAlerts{
    private weak var viewcontroller:ClassYearViewController!
    private var addNewClassCompletedAlert:InfoAlert!
    private var classOrMajor:ClassAndMajorProtocol!
    
    init(viewcontroller:ClassYearViewController, classOrMajor:ClassAndMajorProtocol){
        self.viewcontroller = viewcontroller
        self.classOrMajor = classOrMajor
        setupAlerts()
    }
    
    func setupAlerts(){
        setupAddNewClassCompleteAlert()
    }
    
    func showAddNewClassCompleteAlert(){
        addNewClassCompletedAlert.show(viewcontroller: viewcontroller)
    }
    func showAddNewClassCompleteAlertWithHandler(showAlertCompleteHandler: (()->Void)?){
        addNewClassCompletedAlert.show(viewcontroller: viewcontroller, showAlertCompleteHandler: showAlertCompleteHandler)
    }
    
    func showAlert(title:String,message:String){
        let generalAlert = InfoAlert(title: title, message: message, alertType: .Error)
        generalAlert.show(viewcontroller: viewcontroller)
    }
    
    private func setupAddNewClassCompleteAlert(){
        var title:String!
        
        if(classOrMajor is Class){
            title = "Chọn lớn thành công!"
        }
        else{
            title = "Chọn khoa thành công!"
        }
        
        let message = "Bước Tiếp Theo: Thêm Bạn Vào Danh Sách"
        
        addNewClassCompletedAlert = InfoAlert(title: title, message: message, alertType: .Success)
    }
    
}
