//
//  ClassDetailController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/4/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ClassDetailController{
    var students = [Student]()
    var classEnrollRef:DatabaseReference!
    
    init(classProtocol:ClassProtocol){
        classEnrollRef = Database.database().reference().child("students").child(classProtocol.getFirebasePathWithSchoolYear())
    }
    
    func fetchData(completionHandler: @escaping (_ uiState:UIState) -> Void){
        students.removeAll()
        
        classEnrollRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for snap in snapshot.children {
                let uid = (snap as! DataSnapshot).key
                
                AllUserHelper.getAnyStudentFromDatabase(uid: uid, completionHandler: { (student) in
                    self.students.append(student)
                    
                    if(self.students.count == snapshot.children.allObjects.count){
                        completionHandler(.Success())
                    }
                })
            }
            
            if(snapshot.children.allObjects.count == 0){
                completionHandler(.Success())
            }
        }) { (error) in
            
            completionHandler(.Failure(error.localizedDescription))
        }
        
    }
    
    func enrollUserToClass(completionHandler: @escaping (_ uiState:UIState) -> Void){
        classEnrollRef.child(CurrentUserHelper.getUid()).setValue(CurrentUserHelper.getFullname()) { (error, ref) in
            if(error == nil){
                self.students.append(CurrentUserHelper.getStudent())
                completionHandler(.Success())
            }
            else{
                completionHandler(.Failure((error?.localizedDescription)!))
            }
        }
    }
}
