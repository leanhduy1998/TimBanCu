//
//  SchoolType.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/29/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase


enum EducationLevel{
    case Elementary
    case MiddleSchool
    case HighSchool
    case University
    
    func getShortString()->String{
        switch(self){
        case .Elementary:
            return Constants.elementaryString
        case .MiddleSchool:
            return Constants.middleSchoolString
        case .HighSchool:
            return Constants.highschoolString
        case .University:
            return Constants.universityString
        }
    }
    
    func getFullString()->String{
        switch(self){
        case .Elementary:
            return "elementary"
        case .MiddleSchool:
            return "middleSchool"
        case .HighSchool:
            return "highSchool"
        case .University:
            return "university"
        }
    }
}
