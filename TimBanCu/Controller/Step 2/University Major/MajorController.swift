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
    var majors = [Major]()
    var school:InstitutionFull!
    
    private weak var viewcontroller:MajorViewController!
    
    init(viewcontroller:MajorViewController, school:InstitutionFull){
        self.school = school
        self.viewcontroller = viewcontroller
    }
    
  
    func fetchData(completionHandler: @escaping (_ state:UIState)->Void){
        FirebaseDownloader.shared.getMajors(institution: school) { (uiState, majors) in
            switch(uiState){
            case .Success():
                self.majors = majors!
                completionHandler(uiState)
                break
            case .Failure(_):
                completionHandler(uiState)
                break
            default:
                break
            }
        }
    }
    
    func addNewMajor(majorName:String,completionHandler: @escaping (_ err:String?)->Void){
        let major = Major(institution: school, uid: CurrentUser.getUid(), majorName: majorName)
        majors.append(major)
        viewcontroller.selectedMajor = major
        
        FirebaseUploader.shared.uploadMajor(model: major, completionHandler: completionHandler)
    }
}
