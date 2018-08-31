//
//  MajorController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/31/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class MajorController{
    var majors = [MajorDetail]()
    var school:School!
    
    private var queryTool:SchoolQueryTool!
    
    init(school:School){
        self.school = school
    }
    
  
    func fetchData(completionHandler: @escaping (_ state:UIState)->Void){
        Database.database().reference().child("classes").child(school.name).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
        }) { (err) in
            completionHandler(.Failure(err.localizedDescription))
        }
    }
    
    func addNewMajor(name:String,completionHandler: @escaping (_ state:UIState)->Void){
      //  let major = MajorDetail(uid: CurrentUserHelper.getUid(), schoolName: self.school.name, majorName: inputedMajorName)
        
     //   self.selectedMajor = major
    }
}
