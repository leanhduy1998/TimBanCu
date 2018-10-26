//
//  ClassAndMajorProtocol.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/24/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation

protocol ClassAndMajorProtocol {
    var uid:String! { get set }
    var institution:Institution! { get set }
    func classYearExist(year:String,completionHandler: @escaping (_ exist:Bool) -> Void)
    func uploadToFirebase(completionHandler: @escaping (_ state:UIState)->Void)
}
