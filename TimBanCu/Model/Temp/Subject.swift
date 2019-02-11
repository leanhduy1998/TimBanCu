//
//  Subject.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/3/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation

class Subject{
    private var observers:[Observer]!
    
    init(){
        
    }
    
    func attach(observer:Observer){
        observers.append(observer)
    }
    
    func detachAll(){
        observers.removeAll()
    }
    
    func notify(){
        for ob in observers{
            ob.onDataUpdated()
        }
    }
    
}
