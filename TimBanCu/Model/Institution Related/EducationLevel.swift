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
            return Constants.elementaryString
        case .MiddleSchool:
            return Constants.middleSchoolString
        case .HighSchool:
            return Constants.highschoolString
        case .University:
            return Constants.universityString
        }
    }
    
    func getInstitutions(completionHandler: @escaping (_ state:QueryState) -> Void){
        let schoolsRef = Database.database().reference().child("schools")
        var query:DatabaseQuery!
        let queryOrderedByType = schoolsRef.queryOrdered(byChild: "type")
        
        query = queryOrderedByType.queryEqual(toValue : self.getString())
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            completionHandler(.Success(snapshot))
        }) { (error) in
            completionHandler(.Fail(error))
        }
    }
}
