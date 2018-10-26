//
//  ClassAndMajorWithYearProtocol.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/24/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol ClassAndMajorWithYearProtocol {
    func copy()->ClassAndMajorWithYearProtocol
    func objectAsDictionary()->[String:[String:String]]
    func addToPublicStudentListOnFirebase(student:Student,completionHandler: @escaping (_ uiState:UIState) -> Void)
    func getInstitution() -> Institution
    func getFirebasePath()->String
    static func get(institution:Institution, completionHandler: @escaping (ClassAndMajorWithYearProtocol) -> Void)
}

extension ClassAndMajorWithYearProtocol{
    static func get(institution:Institution, completionHandler: @escaping (ClassAndMajorWithYearProtocol) -> Void){
        
    }
}

