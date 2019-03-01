//
//  SchoolController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/29/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class SchoolController:Subject{
    private var educationLevel:EducationLevel!
    var institutions = [InstitutionFull]() {
        didSet{
            notify()
        }
    }
    
    init(educationLevel:EducationLevel){
        self.educationLevel = educationLevel
    }
    
 
    func fetchData(completionHandler: @escaping (_ state:UIState)->Void){
        FirebaseDownloader.shared.getInstitutions(educationalLevel: educationLevel) { [weak self] (institutions, state) in
            
            guard let strongself = self else{
                return
            }
            
            switch(state){
            case .Success():
                strongself.institutions = institutions!
                completionHandler(.Success())
                break
            case .Failure(let error):
                completionHandler(.Failure(error))
                break
            default:
                break
            }
        }
    }
    
    func addNewInstitution(name:String,completionHandler: @escaping (_ state:UIState)->Void){
        let institution = InstitutionFull(name: name, type: educationLevel.getShortString(), addByUid: CurrentUser.getUid())
        
        FirebaseUploader.shared.uploadInstitution(institution: institution) { [weak self] (err, _) in
            
            guard let strongself = self else{
                return
            }
            
            if(err == nil){
                strongself.institutions.append(institution)
                completionHandler(.Success())
            }
            else{
                let errorStr:String = (err?.localizedDescription)!
                completionHandler(.Failure(errorStr))
            }
        }
    }
}
