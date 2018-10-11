//
//  ClassDetailController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/4/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class ClassDetailController{
    var students = [Student]()
    private var classEnrollRef:DatabaseReference!
    private var classProtocol:ClassProtocol!
    
    private var storage = Storage.storage().reference()
    
    init(classProtocol:ClassProtocol){
        self.classProtocol = classProtocol
        classEnrollRef = Database.database().reference().child("students").child(classProtocol.getFirebasePathWithSchoolYear())
        createCopyOfClassProtocol()
    }
    
    // if the user goes back and forth between the screen, the same protocol will be used, thus same protocol for multiple class like school and major. So we create a copy so major and school won't get mixed up. Could have used struct, but in ClassYear we needed to change the year
    private func createCopyOfClassProtocol(){
        if let classDetail = classProtocol as? ClassDetail{
            let copy = ClassDetail(classNumber: classDetail.classNumber, uid: classDetail.uid, schoolName: classDetail.schoolName, className: classDetail.className, classYear: classDetail.year)
            classProtocol = copy
        }
        if let majorDetail = classProtocol as? MajorDetail{
            let copy = MajorDetail(uid: majorDetail.uid, schoolName: majorDetail.schoolName, majorName: majorDetail.majorName, majorYear: majorDetail.year)
            classProtocol = copy
        }
    }
    
    func fetchStudents(completionHandler: @escaping (_ uiState:UIState) -> Void){
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
    
    func fetchStudentsImages(completionHandler: @escaping (_ uiState:UIState) -> Void){
        var count = 0
        var errStr:String?
        
        for student in students{
            storage.child("users/\(student.uid!)/\(student.images[0].imageName!)").getData(maxSize: INT64_MAX) { (imageData, error) in
                
                if(error != nil){
                    errStr = error.debugDescription
                }
                else{
                    student.images[0].image = UIImage(data: imageData!)
                }
                
                count+=1
            
                if(count == self.students.count){
                    if(errStr == nil){
                        completionHandler(.Success())
                    }
                    else{
                        completionHandler(.Failure(errStr!))
                    }
                }
            }
        }
    }
}
