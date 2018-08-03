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
    func tieuhocQuery(completionHandler: @escaping () -> Void) {
        tieuhocQueryRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let value = (snap as! DataSnapshot).value as? [String:Any]
                
                let name = (snap as! DataSnapshot).key
                let address = value!["address"] as? String
                let uid = value!["uid"] as? String
                
                let school = School(name: name, address: address!, type: "th", uid: uid!)
                
                self.schoolModels.append(school)
            }
            completionHandler()
        }
    }
    
    func thcsQuery(completionHandler: @escaping () -> Void) {
        thcsQueryRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let value = (snap as! DataSnapshot).value as? [String:Any]
                
                let name = (snap as! DataSnapshot).key
                let address = value!["address"] as? String
                let uid = value!["uid"] as? String
                
                let school = School(name: name, address: address!, type: "thcs", uid: uid!)
                
                self.schoolModels.append(school)
            }
            completionHandler()
        }
    }
    
    func thptQuery(completionHandler: @escaping () -> Void) {
        thptQueryRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let value = (snap as! DataSnapshot).value as? [String:Any]
                
                let name = (snap as! DataSnapshot).key
                let address = value!["address"] as? String
                let uid = value!["uid"] as? String
                
                let school = School(name: name, address: address!, type: "thpt", uid: uid!)
                
                self.schoolModels.append(school)
            }
            
            completionHandler()
        }
    }
    
    func daihocQuery(completionHandler: @escaping () -> Void) {
        daihocQueryRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let value = (snap as! DataSnapshot).value as? [String:Any]
                
                let name = (snap as! DataSnapshot).key
                let address = value!["address"] as? String
                let uid = value!["uid"] as? String
                
                let school = School(name: name, address: address!, type: "dh", uid: uid!)
                
                self.schoolModels.append(school)
            }
            
            completionHandler()
        }
    }
    
    
    

    
}
