//
//  ClassDetailViewExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension ClassDetailViewController{
    
    func setupNoResultLabelAndButton(topViewY:CGFloat, topViewHeight:CGFloat){
        view.addSubview(noResultLabel)
        view.addSubview(noResultAddNewClassBtn)
        
        view.bringSubview(toFront: noResultLabel)
        view.bringSubview(toFront: noResultAddNewClassBtn)
        
        noResultLabel.text = "Chưa có lớp. Bạn có muốn thêm lớp? Ví dụ: 10A11"
        noResultLabel.textColor = UIColor.darkGray
        noResultLabel.textAlignment = .center
        noResultLabel.numberOfLines = 2
        noResultLabel.translatesAutoresizingMaskIntoConstraints = false

        noResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        noResultLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        noResultLabel.rightAnchor.constraint(equalTo: view.leftAnchor, constant: -40).isActive = true
        noResultLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let y = topViewY + topViewHeight + 40
        noResultAddNewClassBtn.frame = CGRect(x: 0, y: y + 80, width: view.frame.width, height: 40)
        noResultAddNewClassBtn.setAttributedTitle(NSAttributedString(string: "Thêm Lớp Mới", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold), NSAttributedStringKey.foregroundColor: UIColor(red: 255/255, green: 158/255, blue: 0/255, alpha: 1.0)]), for: .normal)
        
        noResultAddNewClassBtn.addTarget(self, action: #selector(self.addNewClassDetailBtnPressed(_:)), for: .touchUpInside)
    }
    
    func updateTableviewVisibilityBasedOnSearchResult(){
        if(searchClassDetails.count == 0){
            noResultLabel.isHidden = false
            noResultAddNewClassBtn.isHidden = false
            tableview.isHidden = true
        }
        else{
            noResultLabel.isHidden = true
            noResultAddNewClassBtn.isHidden = true
            tableview.isHidden = false
            tableview.reloadData()
        }
    }
}
