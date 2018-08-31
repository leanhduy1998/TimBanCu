//
//  GenericTableView.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/30/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class GenericTableViewTool<Item,Cell:UITableViewCell>: NSObject, UITableViewDelegate,UITableViewDataSource{
    var items: [Item]!
    var configure: (Cell, Item) -> ()
    var reuseIdentifier:String!
    var didSelect: (Item) -> () = { _ in }
    
    var tableview: UITableView!
    var finishedLoadingInitialTableCells = false
    
    init(tableview:UITableView, items: [Item], configure: @escaping (Cell, Item) -> ()) {
        self.configure = configure
        super.init()
        
        self.tableview = tableview
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        
        self.items = items
        reuseIdentifier = String(describing: Cell.self)
        
        //self.tableview.register(Cell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Cell
        let item = items[indexPath.row]
        configure(cell, item)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        didSelect(item)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastInitialDisplayableCell = tableView.animateOnlyBeginingCells(tableView: tableView, indexPath: indexPath, model: items as! [AnyObject], finishLoading: finishedLoadingInitialTableCells)
        
        
        
        if !finishedLoadingInitialTableCells {
            if lastInitialDisplayableCell {
                finishedLoadingInitialTableCells = true
            }
            tableview.animateCells(cell: cell, tableView: tableview, indexPath: indexPath)
        }
    }

}
