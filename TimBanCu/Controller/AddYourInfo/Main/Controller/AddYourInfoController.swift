//
//  AddYourInfoController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/11/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class AddYourInfoController{
    
    fileprivate var classProtocol:ClassAndMajorWithYearProtocol?
    

    init(classProtocol:ClassAndMajorWithYearProtocol?){
        self.classProtocol = classProtocol
    }
    
    private var finishUploadingDataToDatabase = false
    private var finishEnrollUserToClass = false
    
    // TODO: Write unit test to make sure all the strings are not empty
    func updateUserInfo(student:Student, completeUploadClosure:@escaping (_ uistate:UIState)->Void){
        
        finishUploadingDataToDatabase = false
        finishEnrollUserToClass = false
        
 
        if shouldEnrollUser(){
            enrollUserIntoClass { [weak self] (status) in
                guard let strongself = self else{
                    return
                }
                
                switch(status){
                case .Success():
                    strongself.finishEnrollUserToClass = true
                    if strongself.isUploadingComplete(){
                        completeUploadClosure(.Success())
                    }
                    break
                case .Failed(let errMsg):
                    completeUploadClosure(.Failure(errMsg))
                    break
                }
            }
        }
        
        FirebaseUploader.shared.uploadStudentDetailedData(student: student) { [weak self] (uistate) in
            guard let strongself = self else{
                return
            }
            strongself.finishUploadingDataToDatabase = true
            if strongself.isUploadingComplete(){
                completeUploadClosure(.Success())
            }
        }
    }
    
    private func isUploadingComplete()->Bool{
        if(finishUploadingDataToDatabase){
            if shouldEnrollUser(){
                return finishEnrollUserToClass
            }
            else{
                return true
            }
        }
        return false
    }
    
    private func shouldEnrollUser()->Bool{
        return classProtocol != nil
    }
    
    private func enrollUserIntoClass(completionHandler: @escaping (_ status:Status)->()){
        CurrentUser.addEnrollmentLocalAndOnline(classProtocol: classProtocol!) { (uiState) in
            switch(uiState){
            case .Success():
                completionHandler(.Success())
                break
            case .Failure(let errMsg):
                completionHandler(.Failed(errMsg))
                break
            default:
                break
            }
        }
    }
}

