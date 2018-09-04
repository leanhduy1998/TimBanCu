//
//  ClassYearController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/2/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class ClassYearController{
    var years = [String]()
    
    init(){
        setupManualYears()
    }
    
    func checkIfClassYearExist(selectedYear:String,classProtocol:ClassProtocol,completionHandler: @escaping (_ exist:Bool, _ uid:String) -> Void){
        Database.database().reference().child("classes").child(classProtocol.getFirebasePathWithoutSchoolYear()).child(selectedYear).observeSingleEvent(of: .value) { (snapshot) in
            
            let classValue = (snapshot as! DataSnapshot).value as? [String:String]
            
            if(classValue == nil){
                completionHandler(false, "")
            }
            else{
                let uid = classValue!["uid"]
                completionHandler(true, uid!)
            }
            
        }
    }
    
    func writeToDatabaseThenShowCompleteAlert(classProtocol:ClassProtocol,completionHandler: @escaping (_ state:UIState)->Void){
        classProtocol.writeToDatabase { (err, ref) in
            DispatchQueue.main.async {
                if(err == nil){
                    completionHandler(.Success())
                    //self.present(self.addNewClassCompletedAlert, animated: true, completion: nil)
                }
                else{
                    completionHandler(.Failure((err?.localizedDescription)!))
                }
                /*else if(err?.localizedDescription == "Permission denied") {
                    self.present(self.classAlreadyExistAlert, animated: true, completion: nil)
                    
                }*/
            }
        }
    }
    
    private func setupManualYears(){
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        let allowedFurthestYear = year - 80
        
        var index = year
        
        while(index >= allowedFurthestYear){
            let string = "Năm \(index)"
            years.append(string)
            
            index = index - 1
        }
    }
}
