//
//  Class.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ClassWithYear: Class, ClassAndMajorWithYearProtocol{

    var year: String
    
    init(classs:Class,year:String){
        self.year = year
        super.init(classs: classs)
    }
    
    init(classWithYear:ClassWithYear){
        self.year = classWithYear.year
        super.init(institution: classWithYear.institution, classNumber: classWithYear.getClassNumber(), className: classWithYear.getClassName(), uid: classWithYear.uid)
        
    }
    
    func addToPublicStudentListOnFirebase(student:Student,completionHandler: @escaping (_ uiState:UIState) -> Void) {
        Database.database().reference().child(firebaseClassYearPath()).child(student.uid).setValue(student.fullName) { (err, _) in
            if(err == nil){
                completionHandler(.Success())
            }
            else{
                completionHandler(.Failure((err?.localizedDescription)!))
            }
        }
    }
    
    func getInstitution() -> Institution {
        return super.institution
    }
    
    private func firebaseClassYearPath() -> String {
        return firebaseClassYearPath(withParent: "classes")
    }
    
    func firebaseClassYearPath(withParent:String) -> String {
        return "\(withParent)/\(institution.name!)/\(getClassNumber)/\(getClassName())/\(year)"
    }
    
    func objectAsDictionary() -> [String : [String:String]] {
        var dic = [String:[String:String]]()
        dic[institution.name!] = ["className":getClassName(),"uid":uid,"classNumber":getClassNumber(),"year":year]
        return dic
    }

    func copy() -> ClassAndMajorWithYearProtocol {
        return ClassWithYear(classWithYear: self)
    }
        
    
    func uploadToFirebase(year:String,completionHandler: @escaping (UIState) -> Void) {
        Database.database().reference().child(firebaseClassYearPath()).setValue(CurrentUser.getUid()) { (err, _) in
            if(err == nil){
                completionHandler(.Success())
            }
            else{
                completionHandler(.Failure(err.debugDescription))
            }
        }
    }
    
    override func uploadToFirebase(completionHandler: @escaping (UIState) -> Void) {
        fatalError("Not Supported")
    }
}
