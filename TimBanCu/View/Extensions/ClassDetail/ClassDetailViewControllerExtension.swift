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
    override func viewDidLayoutSubviews() {
        setupNoResultLabel(topViewY: searchTF.bounds.origin.y, topViewHeight: searchTF.frame.height)
        view.layoutIfNeeded()
    }
    
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
    
    func updateTableviewVisibilityBasedOnSearchResult(){
        if(searchStudents.count == 0){
            noResultLabel.isHidden = false
            tableview.isHidden = true
        }
        else{
            noResultLabel.isHidden = true
            tableview.isHidden = false
        }
    }
    
    func startLoading(){
        tableview.isHidden = true
        searchTF.isHidden = true
        addYourselfBtn.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopLoading(){
        UIView.animate(withDuration: 1) {
            self.tableview.isHidden = false
            self.searchTF.isHidden = false
            self.activityIndicator.isHidden = true
        }
        activityIndicator.stopAnimating()
    }
}
