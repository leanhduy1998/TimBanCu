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
        educationLevel.getInstitutions { [weak self] (queryState) in
            switch(queryState){
            case .Success(let snapshot):
                self?.institutions = InstitutionFull.getInstitutionsFrom(snapshot: snapshot, educationLevel: self!.educationLevel)
                
                completionHandler(.Success())
                break
            case .Fail(let error):
                completionHandler(.Failure(error.localizedDescription))
                break
            }
        }
    }
    
    func addNewInstitution(name:String,completionHandler: @escaping (_ state:UIState)->Void){
        let institution = InstitutionFull(name: name, type: educationLevel.getShortString(), addByUid: CurrentUser.getUid())
        
        institution.writeToDatabase { [weak self] (err, _) in
            if(err == nil){
                self?.institutions.append(institution)
                completionHandler(.Success())
            }
            else{
                let errorStr:String = (err?.localizedDescription)!
                completionHandler(.Failure(errorStr))
            }
        }
    }
}
