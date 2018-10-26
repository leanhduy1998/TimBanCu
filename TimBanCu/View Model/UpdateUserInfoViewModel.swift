//
//  UpdateUserInfoViewModel.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/24/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation

class UpdateUserInfoViewModel{
    let fullname:String
    let birthYear:String
    let phoneNumber:String
    let email:String
    
    init(student:Student){
        self.fullname = CurrentUser.student.fullName
        self.birthYear = CurrentUser.student.birthYear
        self.phoneNumber = CurrentUser.student.phoneNumber
        self.email = CurrentUser.student.email
    }
}
