//
//  UpdateImageYearAlerts.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/14/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class UpdateImageYearAlerts{
    private var yearOutOfLowerBoundAlert:InfoAlert!
    private var yearIsInTheFutureAlert:InfoAlert!
    
    private weak var viewcontroller:UIViewController!
    
    init(viewcontroller:UIViewController){
        self.viewcontroller = viewcontroller
        
        setupYearOutOfLowerBoundAlert()
    }
    
    func showYearOutOfLowerBoundAlert(){
        yearOutOfLowerBoundAlert.show(viewcontroller: viewcontroller)
    }
    
    func showYearIsInTheFutureAlert(){
        yearIsInTheFutureAlert.show(viewcontroller: viewcontroller)
    }
    
    private func setupYearOutOfLowerBoundAlert(){
        let title = "Năm Quá Xa So Với Hiện Tại"
        let message = "Bạn Vui Lòng Điền Năm Gần Với Hiện Tại Hơn!"
        
        yearOutOfLowerBoundAlert = InfoAlert(title: title, message: message, successAnimation: false)
    }
    
    private func setupYearIsInTheFutureAlert(){
        let title = "Năm Học Ở Trong Tương Lai"
        let message = "Bạn Vui Lòng Điền Năm Ở Trong Quá Khứ Hoặc Ở Hiện Tại"
        
        yearIsInTheFutureAlert = InfoAlert(title: title, message: message, successAnimation: false)
    }
}
