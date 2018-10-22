//
//  GenericTableView.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/30/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class GenericTableView<Item,Cell:UITableViewCell>: NSObject, UITableViewDelegate,UITableViewDataSource{
    var items: [Item]!
    var configure: (Cell, Item) -> ()
    var reuseIdentifier:String!
    var didSelect: (Item) -> () = { _ in }
    
    var tableview: UITableView!
    var finishAnimateCells = false
    
    init(tableview:UITableView, items: [Item], configure: @escaping (Cell, Item) -> ()) {
        self.configure = configure
        super.init()
        
        self.tableview = tableview
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        tableview.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tableview.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        
        
        self.items = items
        reuseIdentifier = String(describing: Cell.self)

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
        
        DispatchQueue.main.async { [weak self] in
            var animateLastCell = false
            
            if !self!.finishAnimateCells {
                if let indexPathsForVisibleRows = self!.tableview.indexPathsForVisibleRows,let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
                    animateLastCell = true
                }
                
                if animateLastCell {
                    self!.finishAnimateCells = true
                }
                
                self!.animateCells(cell: cell, tableView: self!.tableview, indexPath: indexPath)
            }
        }
    }
    
    private func animateCells(cell: UITableViewCell, tableView: UITableView, indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            cell.transform = CGAffineTransform(translationX: 0, y: tableView.rowHeight / 2)
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0.03 * Double(indexPath.row), options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            }, completion: nil)
        }
    }

}
