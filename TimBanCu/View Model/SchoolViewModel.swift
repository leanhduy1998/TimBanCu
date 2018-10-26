//
//  SchoolViewModel.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/9/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class SchoolViewModel{
    var name:String!
    var address:String!
    
    init(school:InstitutionFull){
        self.name = school.name
        self.address = school.address
    }
    

}
