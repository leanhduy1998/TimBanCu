//
//  ClassDetailViewModel.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation

class ClassNameViewModel{
    var className:String!
    
    init(classDetail:ClassDetail){
        self.className = classDetail.className
    }
}
