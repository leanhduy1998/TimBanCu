//
//  MajorViewModel.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/2/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation

class MajorViewModel{
    var majorName:String!
    
    init(major:MajorWithYear){
        self.majorName = major.majorName
    }
}
