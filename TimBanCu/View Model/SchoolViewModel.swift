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
    var image:UIImage!
    var name:String!
    var address:String!
    var type:String!
    
    init(name:String,address:String,image:UIImage){
        self.name = name
        self.address = address
        self.image = image
    }
    
    init(name:String,address:String,type:String){
        self.name = name
        self.address = address
        self.type = type
    }
}
