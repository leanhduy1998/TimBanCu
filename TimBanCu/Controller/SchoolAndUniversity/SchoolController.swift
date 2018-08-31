//
//  SchoolController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/29/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class SchoolController{
    private var schoolType:SchoolType!
    
    var schoolModels = [School]()
    
    private var queryTool:SchoolQueryTool!
    
    init(schoolType:SchoolType){
        self.schoolType = schoolType
        queryTool = SchoolQueryTool(schoolType: schoolType)
    }
    
    private func getSchoolTypeAsString() -> String{
        switch(schoolType){
        case .Elementary:
            return "tieuhoc"
        case .MiddleSchool:
            return "thcs"
        case .HighSchool:
            return "thpt"
        case .University:
            return "dh"
        default:
            return ""
        }
    }
    
 
    func fetchData(completionHandler: @escaping (_ state:UIState)->Void){
        queryTool.getData { (queryState) in
            switch(queryState){
            case .Success(let snapshot):
                self.schoolModels.removeAll()
                
                for snap in snapshot.children {
                    let value = (snap as! DataSnapshot).value as? [String:Any]
                    
                    let name = (snap as! DataSnapshot).key
                    let address = value!["address"] as? String
                    let uid = value!["uid"] as? String
                    
                    let school = School(name: name, address: address!, type: self.getSchoolTypeAsString(), uid: uid!)
                    
                    self.schoolModels.append(school)
                }
                                
                completionHandler(.Success())
                
                break
            case .Fail(let error):
                completionHandler(.Failure(error.localizedDescription))
                break

            }
        }
    }
    
    func addNewSchool(schoolName:String,completionHandler: @escaping (_ state:UIState)->Void){
        let school = School(name: schoolName, address: "?", type: getSchoolTypeAsString(), uid: CurrentUserHelper.getUid())
        
        Database.database().reference().child("schools").child(school.name).setValue(school.getObjectValueAsDic()) { (err, ref) in
            
            if(err == nil){
                completionHandler(.Success())
            }
            else{
                let errorStr:String = (err?.localizedDescription)!
                
                completionHandler(.Failure(errorStr))
            }
        }
        
    }
}
