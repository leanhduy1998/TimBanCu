//
//  SchoolTableViewConfigurator.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/3/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class SchoolTableViewConfigurator:RootTableViewConfigurator{
    func configure(cell: UITableViewCell, model: Model) {
        guard let cell = cell as? SchoolTableViewCell else{
            fatalError("Wrong config")
        }
        guard let model = model as? InstitutionFull else{
            fatalError("Wrong config")
        }
        
        cell.schoolName.text = model.name
        
        if(model.address == nil){
            cell.schoolAddress.text = "Không rõ địa chỉ"
        }
        else{
            cell.schoolAddress.text = model.address
        }
    }
}
