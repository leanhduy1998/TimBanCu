//
//  RootFactory.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class RootFactory{
    static func getSchoolViewController(educationLevel:EducationLevel)->SchoolViewController{
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SchoolViewController") as! SchoolViewController
        controller.setup(educationLevel: educationLevel)
        return controller
    }
    
    
}
