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
    
    private func setupManualYears(){
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        let allowedLowestYear = year - 80
        
        var index = year
        
        while(index >= allowedLowestYear){
            let string = "\(index)"
            years.append(string)
            
            index = index - 1
        }
    }
}
