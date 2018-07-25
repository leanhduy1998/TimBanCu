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
    func setupNoResultLabelAndButton(topViewY:CGFloat, topViewHeight:CGFloat){
        view.addSubview(noResultLabel)
        view.addSubview(noResultAddYourInfoBtn)
        
        view.bringSubview(toFront: noResultLabel)
        view.bringSubview(toFront: noResultAddYourInfoBtn)
        
        noResultLabel.text = "Chưa có học sinh nào. Bạn có muốn thông tin của mình?"
        noResultLabel.textColor = UIColor.darkGray
        noResultLabel.textAlignment = .center
        noResultLabel.numberOfLines = 2
        noResultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        noResultLabel.frame = CGRect(x: 0, y: 40, width: view.bounds.width, height: 40)
        
        
        noResultAddYourInfoBtn.frame = CGRect(x: 0, y: 80, width: view.bounds.width, height: 40)
        
        
        
        noResultAddYourInfoBtn.setAttributedTitle(NSAttributedString(string: "Thêm Thông Tin", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold), NSAttributedStringKey.foregroundColor: UIColor(red: 255/255, green: 158/255, blue: 0/255, alpha: 1.0)]), for: .normal)
        
        noResultAddYourInfoBtn.addTarget(self, action: #selector(self.addYourInfoBtnPressed(_:)), for: .touchUpInside)
    }
    
    func updateTableviewVisibilityBasedOnSearchResult(){
        if(searchStudents.count == 0){
            noResultLabel.isHidden = false
            noResultAddYourInfoBtn.isHidden = false
            tableview.isHidden = true
        }
        else{
            noResultLabel.isHidden = true
            noResultAddYourInfoBtn.isHidden = true
            tableview.isHidden = false
            tableview.reloadData()
        }
    }
}
