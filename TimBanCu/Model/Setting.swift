//
//  Setting.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/10/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class Setting{
    enum SettingEnum{
        case Edit
        case SignOut
        
        func getString()->String{
            switch(self){
            case .Edit:
                return "Sửa Thông Tin Cá Nhân"
            case .SignOut:
                return "Đăng Xuất"
            }
        }
        
        func getIconName()->UIImage{
            switch(self){
            case .Edit:
                return UIImage(named: "Edit2")!
            case .SignOut:
                return UIImage(named: "signOut2")!
            }
        }
    }

    static func getAllSettings()->[Setting.SettingEnum]{
        return [SettingEnum.Edit,SettingEnum.SignOut]
    }
}
