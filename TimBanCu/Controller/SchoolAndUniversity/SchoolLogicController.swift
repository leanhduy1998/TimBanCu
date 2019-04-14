//
//  SchoolLogicController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation

class SchoolLogicController{
    func filter(name:String, institutions:[InstitutionFull])->[InstitutionFull]{
        
        if(name.isEmpty){
            return institutions
        }
        else{
            var filteredList = [InstitutionFull]()
            
            for institution in institutions{
                if institution.name.lowercased().range(of:name.lowercased()) != nil {
                    filteredList.append(institution)
                }
            }
            return filteredList
        }
    }
}
