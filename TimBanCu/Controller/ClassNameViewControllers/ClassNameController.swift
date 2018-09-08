//
//  ClassNameController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/2/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ClassNameController{
    var classDetails = [ClassDetail]()
    private var school:School!
    private var classNumber: String!
    private weak var viewcontroller:ClassNameViewController!
    
    init(viewcontroller:ClassNameViewController,school:School,classNumber: String){
        self.school = school
        self.classNumber = classNumber
        self.viewcontroller = viewcontroller
    }
    
    func fetchData(completionHandler: @escaping (UIState) -> ()){
        classDetails.removeAll()
        
        Database.database().reference().child("classes").child(school.name).child(classNumber).observeSingleEvent(of: .value) { (snapshot) in
            
            
            for snap in snapshot.children{
                let className = (snap as! DataSnapshot).key
                
                let classDetail = ClassDetail(classNumber: self.classNumber, uid: "?", schoolName: self.school.name, className: className, classYear: "?")
                
                self.classDetails.append(classDetail)
            }
            
            completionHandler(.Success())
        }
    }
    
    func addNewClass(className:String,completionHandler: @escaping (_ state:UIState)->Void){
        let classDetail = ClassDetail(classNumber: self.classNumber, uid: CurrentUserHelper.getUid(), schoolName: self.school.name, className: className.uppercased())
        classDetails.append(classDetail)
        viewcontroller.selectedClassDetail = classDetail
        completionHandler(.Success())
    }
}
