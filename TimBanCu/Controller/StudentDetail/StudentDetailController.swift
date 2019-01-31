//
//  StudentDetailController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/19/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseStorage

class StudentDetailController{
    private var viewcontroller:StudentDetailViewController!
    private var student:Student!
    
    init(viewcontroller:StudentDetailViewController){
        self.viewcontroller = viewcontroller
        self.student = viewcontroller.student
    }
    
    func fetchStudentImages(completionHandler: @escaping (_ uiState:UIState) -> Void) {
        viewcontroller.userImages.removeAll()
        
        student.getImages { (uistate) in
            switch(uistate){
            case .Success():
                for image in self.student.images{
                    self.viewcontroller.userImages.append(image)
                }
                completionHandler(uistate)
                break
            default:
                completionHandler(uistate)
                break
            }
        }
    }
}
