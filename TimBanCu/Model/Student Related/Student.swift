//
//  Student.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/16/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class Student{
    var fullName:String!
    var birthYear:String!
    var phoneNumber:String!
    var email:String!
    var images: [Image]!
    var uid:String!
    
    var storage = Storage.storage().reference()
    
    var enrolledIn:[ClassAndMajorWithYearProtocol]!
    init(fullname:String,birthYear:String,phoneNumber:String,email:String,uid:String){
        self.fullName = fullname
        self.birthYear = birthYear
        self.phoneNumber = phoneNumber
        self.email = email
        self.images = []
        self.enrolledIn = []
        self.uid = uid
    }
  init(fullname:String,birthYear:String,phoneNumber:String,email:String,uid:String,enrolledIn:[ClassAndMajorWithYearProtocol]){
        self.fullName = fullname
        self.birthYear = birthYear
        self.phoneNumber = phoneNumber
        self.email = email
        self.images = []
        self.enrolledIn = enrolledIn
        self.uid = uid
    }
    
    
    init(){
        self.fullName = nil
        self.birthYear = nil
        self.phoneNumber = nil
        self.email = nil
        self.images = []
        self.enrolledIn = []
        self.uid = nil
    }
    
    init(student:Student){
        self.fullName = student.fullName
        self.birthYear = student.birthYear
        self.phoneNumber = student.phoneNumber
        self.email = student.email
        self.images = student.images
        self.enrolledIn = student.enrolledIn
        self.uid = student.uid
    }
    
    
    static func getFromDatabase(withUid:String,completionHandler: @escaping (_ student:Student) -> Void){
        
        let student = Student()
        student.uid = withUid
        
        student.getPublicData{
            student.getPrivateData {
                completionHandler(student)
            }
        }
    }
    
    private func getPublicData(completionHandler: @escaping () -> Void){
        PublicProfile.getData(student: self, completionHandler: completionHandler)
    }
    
    private func getPrivateData(completionHandler: @escaping () -> Void){
        PrivateProfile.getData(student: self, completionHandler: completionHandler)
    }
    
    func getFirstImage(completionHandler: @escaping (_ uiState:UIState) -> Void){
        if(images.count == 0){
            completionHandler(.Failure("Không có hình"))
        }
        
        storage.child(firebaseStorageFirstImagePath()).getData(maxSize: INT64_MAX) { [weak self] (imageData, error) in
            
            if(error != nil){
                completionHandler(.Failure(error.debugDescription))
            }
            else{
                self!.images[0].image = UIImage(data: imageData!)
                completionHandler(.Success())
            }
        }
    }
    
    func firebaseStorageFirstImagePath()->String{
        if(images.count == 0){
            fatalError()
        }
        return "users/\(uid!)/\(images[0].imageName!)"
    }
    
    func enrollToClassInFirebase(to:ClassAndMajorWithYearProtocol,completionHandler: @escaping (_ uiState:UIState) -> Void){
        
        to.addToPublicStudentListOnFirebase(student: self, completionHandler: completionHandler)

        PublicProfile.addToPersonalEnrollmentListOnFirebase(uid: CurrentUser.getUid(), classOrMajor: to)
    }
    
    static func getStudents(from: ClassAndMajorWithYearProtocol,completionHandler: @escaping (_ uiState:UIState, _ students:[Student]) -> Void){
        
        let studentRef = Database.database().reference().child(from.firebaseClassYearPath(withParent: "classes"))

        var students = [Student]()
        
        studentRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for snap in snapshot.children {
                let uid = (snap as! DataSnapshot).key
                
                Student.getFromDatabase(withUid: uid, completionHandler: {  (student) in
                    students.append(student)
                    
                    if(students.count == snapshot.children.allObjects.count){
                        completionHandler(.Success(),students)
                    }
                })
            }
            
            if(snapshot.children.allObjects.count == 0){
                completionHandler(.Success(), students)
            }
        }) { (error) in
            completionHandler(.Failure(error.localizedDescription),[Student]())
        }
    }
    
    func isStudentInfoCompleted() -> Bool{
        if(fullName.isEmpty){
            return false
        }
        if(birthYear.isEmpty){
            return false
        }
        if(phoneNumber.isEmpty){
            return false
        }
        if(email.isEmpty){
            return false
        }
        if(uid.isEmpty){
            return false
        }
        return true
    }
    
    func getModelAsDictionary() -> [String:Any]{
        var imageNameAndYear = [String:String]()
        for image in images{
            imageNameAndYear[image.imageName] = image.year
        }
        
        return ["fullName":fullName,"birthday":birthYear,"phoneNumber":phoneNumber,"email":email,"imageUrls":imageNameAndYear,"enrolledIn":enrolledIn]
    }
}
