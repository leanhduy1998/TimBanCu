//
//  SchoolQuery.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase


final class SchoolQueryTool{
    
    private var tieuhocQuery:DatabaseQuery!
    private var thcsQuery:DatabaseQuery!
    private var thptQuery:DatabaseQuery!
    private var daihocQuery:DatabaseQuery!
    
    private var schoolType: SchoolType!
    
    init(schoolType: SchoolType){
        self.schoolType = schoolType
        setupSchoolFirebaseReferences()
    }
    
    
    func setupSchoolFirebaseReferences(){
        let schoolsRef = Database.database().reference().child("schools")
        
        let queryOrderedByType = schoolsRef.queryOrdered(byChild: "type")
        
        tieuhocQuery = queryOrderedByType.queryEqual(toValue : "th")
        thcsQuery = queryOrderedByType.queryEqual(toValue : "thcs")
        thptQuery = queryOrderedByType.queryEqual(toValue : "thpt")
        daihocQuery = queryOrderedByType.queryEqual(toValue : "dh")
    }
    
    func getData(completionHandler: @escaping (_ state:QueryState) -> Void){
        
        var query:DatabaseQuery!
        
        switch(schoolType){
        case .Elementary?:
            query = tieuhocQuery
            break
        case .MiddleSchool?:
            query = thcsQuery
            break
        case .HighSchool?:
            query = thptQuery
            break
        case .University?:
            query = daihocQuery
            break
            
        default:
            break
        }
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            completionHandler(.Success(snapshot))
        }) { (error) in
            completionHandler(.Fail(error))
        }
        
    }
}
