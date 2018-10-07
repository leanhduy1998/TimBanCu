//
//  UserUniversityViewModel.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/6/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class UserUniversityViewModel {
    var majorName:String!
    var schoolName:String!
    var classYear:String!
    
    init(majorDetail:MajorDetail){
        self.majorName = majorDetail.majorName
        self.schoolName = majorDetail.schoolName
        self.classYear = majorDetail.year
    }
}
