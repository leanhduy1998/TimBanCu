//
//  Class.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ClassWithYear: Class, ClassAndMajorWithYearProtocol{
    var year: String
    
    init(classs:Class,year:String){
        self.year = year
        super.init(classs: classs)
    }
    
    init(classWithYear:ClassWithYear){
        self.year = classWithYear.year
        super.init(institution: classWithYear.institution, classNumber: classWithYear.classNumberString, className: classWithYear.classNameString, uid: classWithYear.uid)
        
    }
    
    func getInstitution() -> Institution {
        return super.institution
    }
    
    func objectAsDictionary() -> [String : [String:String]] {
        var dic = [String:[String:String]]()
        dic[institution.name!] = ["className":getClassName(),"uid":uid,"classNumber":getClassNumber(),"year":year]
        return dic
    }

    func copy() -> ClassAndMajorWithYearProtocol {
        return ClassWithYear(classWithYear: self)
    }
}
