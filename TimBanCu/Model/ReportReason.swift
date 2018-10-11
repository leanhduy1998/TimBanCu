//
//  ReportReason.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/10/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation

class ReportReason{
    enum Reason{
        case AbusiveUser
        case ObjectionableContent
        
        func getString()->String{
            switch(self){
            case .AbusiveUser:
                return "Người dùng có hành vi quấy rối"
            case .ObjectionableContent:
                return "Thông tin phản cảm"
            }
        }
    }
    
    static func getAllReason()->[ReportReason.Reason]{
        return [.AbusiveUser,.ObjectionableContent]
    }
    
    
}
