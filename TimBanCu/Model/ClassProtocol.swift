//
//  Class.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/18/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol ClassProtocol{
    var year:String! { get set }
    var uid:String!{ get set }
    
    func getFirebasePathWithoutSchoolYear()->String
    func getFirebasePathWithSchoolYear()->String
}
