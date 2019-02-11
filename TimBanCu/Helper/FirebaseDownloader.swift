//
//  FirebaseDownloader.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseDownloader{
    static func getStudent(with uid:String,@escaping completionHandler: (_ student:Student?)->Void){
        FirebaseSnapshotDownloader.getStudent(with: uid) { (publicSS, privateSS, state) in
            if state == UIState.Success(){
                let student = FirebaseSnapshotParser.getStudent(uid: uid, publicSS: publicSS, privateSS: privateSS)
                
            }
        }
    }
}
