//
//  ClassNumberViewModel.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/24/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation

class ClassNumberViewModel{
    let classNumbers:[String]
    
    init(educationLevel:EducationLevel){
        switch(educationLevel){
        case .Elementary:
            classNumbers = ["Lớp 1", "Lớp 2", "Lớp 3", "Lớp 4", "Lớp 5"]
            break
        case .MiddleSchool:
            classNumbers = ["Lớp 6", "Lớp 7", "Lớp 8", "Lớp 9"]
            break
        case .HighSchool:
            classNumbers = ["Lớp 10", "Lớp 11", "Lớp 12"]
            break
        case .University:
            classNumbers = []
            break
        }
        
    }
}
