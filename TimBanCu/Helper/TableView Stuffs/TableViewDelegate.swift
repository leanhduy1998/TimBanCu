//
//  TableViewDelegate.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/3/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class TableViewDelegate:NSObject, UITableViewDelegate{
    typealias DidSelect = (_ atIndexPath: IndexPath)->Void
    
    private let didSelect:DidSelect
    
    init(didSelect:@escaping DidSelect){
        self.didSelect = didSelect
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect(indexPath)
    }
}
