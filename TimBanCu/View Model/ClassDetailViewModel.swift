//
//  ClassDetailViewModel.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/16/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation

class ClassDetailViewModel{
    var studentName:String!
    
    init(student:Student){
        self.studentName = student.fullName
    }
}
