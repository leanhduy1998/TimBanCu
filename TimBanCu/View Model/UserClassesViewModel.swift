//
//  UserClassesViewModel.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/18/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class UserClassesViewModel {
    var className:String!
    var schoolName:String!
    var classYear:String!
    
    init(classDetail:ClassDetail){
        self.className = classDetail.className
        self.schoolName = classDetail.schoolName
        self.classYear = classDetail.year
    }
}
