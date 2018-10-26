//
//  ClassDetailController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/4/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class ClassDetailController{
    var students = [Student]()

    private var classProtocol:ClassAndMajorWithYearProtocol!
    
    private var storage = Storage.storage().reference()
    
    init(classProtocol:ClassAndMajorWithYearProtocol){
        // if the user goes back and forth between the screen, the same protocol will be used, thus same protocol for multiple class like school and major. So we create a copy so major and school won't get mixed up. Could have used struct, but in ClassYear we needed to change the year
        self.classProtocol = classProtocol.copy()
    }
    
    
    func fetchStudents(completionHandler: @escaping (_ uiState:UIState) -> Void){
        Student.getStudents(from: classProtocol, completionHandler: { (uiState, students) in
            switch(uiState){
            case .Success():
                self.students = students
                completionHandler(.Success())
                break
            case .Failure(let errString):
                completionHandler(.Failure(errString))
                break
            default:
                break
            }
        })
    }
    
    func fetchStudentsImages(completionHandler: @escaping (_ uiState:UIState) -> Void){
        var count = 0
        
        for student in students{
            student.getFirstImage { (uiState) in
                switch(uiState){
                case .Success():
                    count+=1
                    completionHandler(.Success())
                    break
                case .Failure(_):
                    completionHandler(uiState)
                    break
                default:
                    break
                }
            }
        }
    }
}
