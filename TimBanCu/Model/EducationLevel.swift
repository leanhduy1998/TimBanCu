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
    
    
    
    func getString()->String{
        switch(self){
        case .Elementary:
            return "th"
        case .MiddleSchool:
            return "thcs"
        case .HighSchool:
            return "thpt"
        case .University:
            return "dh"
        }
    }
    
    func getInstitutions(completionHandler: @escaping (_ state:QueryState) -> Void){
        let schoolsRef = Database.database().reference().child("schools")
        var query:DatabaseQuery!
        let queryOrderedByType = schoolsRef.queryOrdered(byChild: "type")
        
        switch(self){
        case .Elementary:
            query = queryOrderedByType.queryEqual(toValue : "th")
            break
        case .MiddleSchool:
            query = queryOrderedByType.queryEqual(toValue : "thcs")
            break
        case .HighSchool:
            query = queryOrderedByType.queryEqual(toValue : "thpt")
            break
        case .University:
            query = queryOrderedByType.queryEqual(toValue : "dh")
            break
            
        }
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            completionHandler(.Success(snapshot))
        }) { (error) in
            completionHandler(.Fail(error))
        }
    }
}
