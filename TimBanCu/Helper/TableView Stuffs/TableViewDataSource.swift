//
//  TableViewDataSource.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/3/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class TableViewDataSource:NSObject,UITableViewDataSource{
    private let models:[Model]
    private let reuseIdentifier:String
    private let configurer:RootTableViewConfigurator
    
    init(models:[Model],reuseIdentifier:String,  configurer:RootTableViewConfigurator){
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.configurer = configurer
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = models[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        configurer.configure(cell: cell, model: model)        
        return cell
    }
    
    
}
