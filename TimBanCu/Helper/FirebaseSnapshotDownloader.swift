//
//  FirebaseDownloader.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseSnapshotDownloader{
    private static let ref = Database.database().reference()
    
    static func getInstitutions(educationalLevel:EducationLevel,completionHandler: @escaping (_ state:QueryState) -> Void){
        let schoolsRef = ref.child("schools")
        var query:DatabaseQuery!
        let queryOrderedByType = schoolsRef.queryOrdered(byChild: "type")
        
        query = queryOrderedByType.queryEqual(toValue : educationalLevel.getShortString())
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            completionHandler(.Success(snapshot))
        }) { (error) in
            completionHandler(.Fail(error))
        }
    }
    
    static func getClasses(institution:Institution,classNumber:String,completionHandler: @escaping (UIState, DataSnapshot?) -> ()){
        
        let path = "classes/\(institution.name!)/\(classNumber)"
        ref.child(path).observeSingleEvent(of: .value, with: { (snapshot) in
            completionHandler(.Success(),snapshot)
        }) { (er) in
            completionHandler(.Failure(er.localizedDescription),nil)
        }
    }
    
    static func getMajor(institution:Institution,completionHandler: @escaping (UIState, DataSnapshot?) -> ()){
        
        let path = "classes/\(institution.name!)"
        
        ref.child(path).observeSingleEvent(of: .value, with: { (snapshot) in
            completionHandler(.Success(),snapshot)
        }) { (er) in
            completionHandler(.Failure(er.localizedDescription),nil)
        }
    }
    
    static func getStudent(with uid:String,completionHandler: @escaping (_ publicSS:DataSnapshot?,_ privateSS:DataSnapshot?, _ state:UIState) -> Void){

        ref.child("publicUserProfile/\(uid)").observeSingleEvent(of: .value, with: { (publicSS) in
            
            ref.child("privateUserProfile/\(uid)").observeSingleEvent(of: .value, with: { (privateSS) in
                
                completionHandler(publicSS,privateSS,.Success())
                
            }, withCancel: { (err) in
                completionHandler(publicSS,nil,.Failure(err.localizedDescription))
            })
            
        }) { (err) in
            completionHandler(nil,nil,.Failure(err.localizedDescription))
        }
        
        
    }
}
