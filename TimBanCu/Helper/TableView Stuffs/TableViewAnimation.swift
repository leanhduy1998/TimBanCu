//
//  CellShowFromBelowAnimator.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/3/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class TableViewAnimation{
    private let lastIndexPath:IndexPath
    private let rowHeight:CGFloat
    
    private var animateLastCell = false
    
    init(tableview: UITableView){
        let indexPathsForVisibleRows = tableview.indexPathsForVisibleRows
        lastIndexPath = indexPathsForVisibleRows!.last!
        
        rowHeight = tableview.rowHeight
    }
    
    func animateCellFromBelowUpAtLoading(cell: UITableViewCell, indexPath: IndexPath){
        if animateLastCell == true{
            return
        }
        
        if lastIndexPath.row == indexPath.row {
            animateLastCell = true
        }
        
        cell.transform = CGAffineTransform(translationX: 0, y: rowHeight / 2)
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.03 * Double(indexPath.row), options: [.curveEaseInOut], animations: {
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            cell.alpha = 1
        }, completion: nil)
    }
}
