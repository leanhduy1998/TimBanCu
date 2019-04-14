//
//  UserClassesViewModel.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/18/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class UserClassViewModel {
    var className:String!
    var schoolName:String!
    var classYear:String!
    
    init(classWithYear:ClassWithYear){
        self.className = classWithYear.classNameString
        self.schoolName = classWithYear.institution.name
        self.classYear = classWithYear.year
    }
}
