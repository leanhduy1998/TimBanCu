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

extension SchoolViewController{
    func setupSchoolFirebaseReferences(){
        let schoolsRef = Database.database().reference().child("schools")
        
        let queryOrderedByType = schoolsRef.queryOrdered(byChild: "type")
        
        tieuhocQuery = queryOrderedByType.queryEqual(toValue : "th")
        thcsQuery = queryOrderedByType.queryEqual(toValue : "thcs")
        thptQuery = queryOrderedByType.queryEqual(toValue : "thpt")
        daihocQuery = queryOrderedByType.queryEqual(toValue : "dh")
    }
    
    func tieuhocGetQuery(completionHandler: @escaping () -> Void) {
        tieuhocQuery.observeSingleEvent(of: .value) { (snapshot) in
            self.convertSnapshotToSchool(snapshot: snapshot, schoolType: "th", completionHandler: completionHandler)
        }
    }
    
    func thcsGetQuery(completionHandler: @escaping () -> Void) {
        thcsQuery.observeSingleEvent(of: .value) { (snapshot) in
            self.convertSnapshotToSchool(snapshot: snapshot, schoolType: "thcs", completionHandler: completionHandler)
        }
    }
    
    func thptGetQuery(completionHandler: @escaping () -> Void) {
        thptQuery.observeSingleEvent(of: .value) { (snapshot) in
            self.convertSnapshotToSchool(snapshot: snapshot, schoolType: "thpt", completionHandler: completionHandler)
        }
    }
    
    func daihocGetQuery(completionHandler: @escaping () -> Void) {
        daihocQuery.observeSingleEvent(of: .value) { (snapshot) in
            self.convertSnapshotToSchool(snapshot: snapshot, schoolType: "dh", completionHandler: completionHandler)
        }
    }
    
    private func convertSnapshotToSchool(snapshot:DataSnapshot, schoolType:String, completionHandler: @escaping () -> Void){
        
        for snap in snapshot.children {
            let value = (snap as! DataSnapshot).value as? [String:Any]
            
            let name = (snap as! DataSnapshot).key
            let address = value!["address"] as? String
            let uid = value!["uid"] as? String
            
            let school = School(name: name, address: address!, type: schoolType, uid: uid!)
            
            self.schoolModels.append(school)
        }
        
        completionHandler()
    }
}
