//
//  QueryState.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/29/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import FirebaseDatabase

enum QueryState{
    case Success(DataSnapshot)
    case Fail(Error)
}

