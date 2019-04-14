//
//  TableViewDataSourceFactory.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/3/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension TableViewDataSource{
    static func make(for models:[InstitutionFull],reuseIdentifier:String,configurer:RootTableViewConfigurator)->TableViewDataSource{
        let dataSource = TableViewDataSource(models: models, reuseIdentifier: reuseIdentifier, configurer: configurer)
        
        return dataSource
    }
}
