//
//  MajorWithYear.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/2/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MajorWithYear: Major, ClassAndMajorWithYearProtocol{

        
    var year:String
    
    init(major:Major,year:String){
        self.year = year
        super.init(major: major)
    }
    
    init(major:MajorWithYear){
        self.year = major.year
        super.init(institution: major.institution, uid: major.uid, majorName: major.majorName)
    }
    
    
    func objectAsDictionary() -> [String : [String:String]] {
        var dic = [String:[String:String]]()
        dic[institution.name!] = ["majorName":majorName,"uid":uid,"year":year]
        return dic
    }
    
    func copy() -> ClassAndMajorWithYearProtocol {
        return MajorWithYear(major: self)
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
    
    private func firebaseClassYearPath() -> String {
        return firebaseClassYearPath(withParent: "classes")
    }
    
    func firebaseClassYearPath(withParent:String) -> String {
        return "\(withParent)/\(institution.name!)/\(majorName!)/\(year)"
    }
    
    func getInstitution() -> Institution {
        return super.institution
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
    
    
    
    
    /*
    
    init(uid:String, schoolName:String, majorName:String,majorYear:String){
        self.uid = uid
        self.schoolName = schoolName
        self.majorName = majorName
        self.year = majorYear
    }
    
    init(uid:String, schoolName:String, majorName:String){
        self.uid = uid
        self.schoolName = schoolName
        self.majorName = majorName
        self.year = "Năm ?"
    }
    
    func getFirebasePathWithoutSchoolYear() -> String {
        return "\(schoolName!)/\(majorName!)"
    }
    
    func getFirebasePathWithSchoolYear() -> String {
        return "\(schoolName!)/\(majorName!)/\(year!)"
    }
    func getModelAsDictionary() -> [String : Any] {
        return ["uid":uid]
    }
    
    func writeToDatabase(completionHandler: @escaping (Error?,DatabaseReference)->Void){
        
        Database.database().reference().child("classes/\(schoolName!)/\(majorName!)/\(year!)").setValue(getModelAsDictionary(), withCompletionBlock: completionHandler)
    }
    
    static func getAllMajorName(completionHandler: @escaping (_ state:UIState, _ majors:[MajorDetail])->Void){
        Database.database().reference().child("classes").child(school.name).observeSingleEvent(of: .value, with: { (snapshot) in
            
            for snap in snapshot.children {
                let value = (snap as! DataSnapshot).value as? [String:Any]
                
                let majorName = (snap as! DataSnapshot).key
                let address = value!["address"] as? String
                let uid = value!["uid"] as? String
                
                let institution = Institution(name: name, address: address!, type: educationLevel.getString(), addByUid: uid!)
                
                institutions.append(institution)
            }
            
            
            completionHandler(.Success())
            
        }) { (err) in
            completionHandler(.Failure(err.localizedDescription))
        }
    }
 */
    
    /*static func getAllMajorFromFirebaseSnapshot(snapshot:DataSnapshot)->[String]{
        var institutions = [Institution]()
        
        for snap in snapshot.children {
            let value = (snap as! DataSnapshot).value as? [String:Any]
            
            let name = (snap as! DataSnapshot).key
            let address = value!["address"] as? String
            let uid = value!["uid"] as? String
            
            let institution = Institution(name: name, address: address!, type: educationLevel.getString(), addByUid: uid!)
            
            institutions.append(institution)
        }
        
        return institutions
    }*/
}

