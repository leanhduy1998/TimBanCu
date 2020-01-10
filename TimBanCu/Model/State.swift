//
//  State.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 3/6/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation

enum State {
    case Loading
    case Success(Any?)
    case Failure(String)
    case Nothing
}
