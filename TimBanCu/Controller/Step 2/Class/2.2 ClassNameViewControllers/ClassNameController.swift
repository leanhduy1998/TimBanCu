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
    var classes = [Class]()
    private var institution:InstitutionFull!
    private var classNumber: String!
    
    init(viewcontroller:ClassNameViewController){
        self.institution = viewcontroller.institution
        self.classNumber = viewcontroller.classNumber
    }
    
    func fetchData(completionHandler: @escaping (UIState) -> ()){
        FirebaseDownloader.shared.getClasses(institution: institution, classNumber: classNumber) { (uiState, classes) in
            switch(uiState){
            case .Success():
                self.classes = classes!
                completionHandler(uiState)
                break
            case .Failure(_):
                completionHandler(uiState)
            default:
                fatalError()
            }
        }
    }
    
    func addNewClass(className:String,completionHandler: @escaping (_ state:UIState)->Void){
        let classN = Class(institution: institution
            , classNumber: classNumber, className: className, uid: CurrentUser.getUid())
        classes.append(classN)
        
        FirebaseUploader.uploadClass(classs: classN, completionHandler: completionHandler)
    }
}
