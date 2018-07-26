//
//  ClassDetailViewControllerExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/17/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension ClassDetailViewController{
    func setupNoResultLabel(topViewY:CGFloat, topViewHeight:CGFloat){
        view.addSubview(noResultLabel)
        view.bringSubview(toFront: noResultLabel)
        
        noResultLabel.text = "Chưa có học sinh nào. Bạn có muốn thông tin của mình?"
        noResultLabel.textColor = UIColor.darkGray
        noResultLabel.textAlignment = .center
        noResultLabel.numberOfLines = 2
        noResultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        noResultLabel.frame = CGRect(x: 0, y: 40, width: view.bounds.width, height: 40)
        
    }
    
    func hideNoResultLabelAndButton(){
        noResultLabel.isHidden = true
        addYourselfBtn.isHidden = true
    }
    func showNoResultLabelAndButton(){
        noResultLabel.isHidden = false
        addYourselfBtn.isHidden = false
    }
    
    func updateTableviewVisibilityBasedOnSearchResult(){
        if(searchStudents.count == 0){
            showNoResultLabelAndButton()
            tableview.isHidden = true
        }
        else{
            hideNoResultLabelAndButton()
            tableview.isHidden = false
            tableview.reloadData()
        }
    }
}
