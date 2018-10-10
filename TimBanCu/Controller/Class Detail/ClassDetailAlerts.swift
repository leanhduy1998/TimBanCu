//
//  ClassDetailAlerts.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/4/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class ClassDetailAlerts{
    private var viewcontroller:UIViewController!
    private var generalErrorAlert = InfoAlert(title: "Lỗi Kết Nối", message: "", successAnimation: false)
    private var addYourInfoCompleteAlert = InfoAlert(title: "Thêm Bạn Vào Danh Sách Thành Công", message: "", successAnimation: true)
    
    init(viewcontroller:UIViewController){
        self.viewcontroller = viewcontroller
    }
    
    func showAddYourInfoCompleteAlert(){
        addYourInfoCompleteAlert.show(viewcontroller: viewcontroller)
    }
    
    func showGeneralErrorAlert(message:String){
        generalErrorAlert.changeMessage(message: message)
        generalErrorAlert.show(viewcontroller: viewcontroller)
    }
}
