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
    private let ref = Database.database().reference()
    
    func getInstitutions(educationalLevel:EducationLevel,completionHandler: @escaping (_ state:UIState, _ snapshot:DataSnapshot?) -> Void){
        let schoolsRef = ref.child("schools")
        var query:DatabaseQuery!
        let queryOrderedByType = schoolsRef.queryOrdered(byChild: "type")
        
        query = queryOrderedByType.queryEqual(toValue : educationalLevel.getShortString())
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            completionHandler(.Success(),snapshot)
        }) { (error) in
            completionHandler(.Failure(error),nil)
        }
    }
    
    func getClasses(institution:Institution,classNumber:String,completionHandler: @escaping (UIState, DataSnapshot?) -> ()){
        
        let path = "classes/\(institution.name!)/\(classNumber)"
        ref.child(path).observeSingleEvent(of: .value, with: { (snapshot) in
            completionHandler(.Success(),snapshot)
        }) { (er) in
            completionHandler(.Failure(er.localizedDescription),nil)
        }
    }
    
    func getMajor(institution:Institution,completionHandler: @escaping (UIState, DataSnapshot?) -> ()){
        
        let path = "classes/\(institution.name!)"
        
        ref.child(path).observeSingleEvent(of: .value, with: { (snapshot) in
            completionHandler(.Success(),snapshot)
        }) { (er) in
            completionHandler(.Failure(er.localizedDescription),nil)
        }
    }
    
    func getStudent(with uid:String,completionHandler: @escaping (_ publicSS:DataSnapshot?,_ privateSS:DataSnapshot?, _ state:UIState) -> Void){

        ref.child("publicUserProfile/\(uid)").observeSingleEvent(of: .value, with: { (publicSS) in
            
            self.ref.child("privateUserProfile/\(uid)").observeSingleEvent(of: .value, with: { (privateSS) in
                
                completionHandler(publicSS,privateSS,.Success())
                
            }, withCancel: { (err) in
                completionHandler(publicSS,nil,.Failure(err.localizedDescription))
            })
            
        }) { (err) in
            completionHandler(nil,nil,.Failure(err.localizedDescription))
        }
    }
    
    func getStudents(from model: ClassWithYear,completionHandler: @escaping (_ snapshot: DataSnapshot) -> Void){
        
        let path = "classes/\(model.institution.name!)/\(model.classNumberString)/\(model.classNameString)/\(model.year)"
        
        ref.child(path).observeSingleEvent(of: .value, with: { (snapshot) in
            completionHandler(snapshot)
            
        })
    }
}
