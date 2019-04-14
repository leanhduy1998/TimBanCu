//
//  MajorWithYear.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/2/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MajorWithYear: Major, ClassAndMajorWithYearProtocol{

        
    var year:String
    
    init(major:Major,year:String){
        self.year = year
        super.init(major: major)
    }
    
    init(major:MajorWithYear){
        self.year = major.year
        super.init(institution: major.institution, uid: major.uid, majorName: major.name)
    }
    
    
    func objectAsDictionary() -> [String : [String:String]] {
        var dic = [String:[String:String]]()
        dic[institution.name!] = ["majorName":name,"uid":uid,"year":year]
        return dic
    }
    
    func copy() -> ClassAndMajorWithYearProtocol {
        return MajorWithYear(major: self)
    }
    
    func getInstitution() -> Institution {
        return super.institution
    }
}

