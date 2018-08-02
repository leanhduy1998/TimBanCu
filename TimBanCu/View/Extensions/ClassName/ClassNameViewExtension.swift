//
//  ClassDetailViewExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension ClassNameViewController{
    
    func setupNoResultLabelAndButton(){
        view.addSubview(noResultLabel)
        view.addSubview(noResultAddNewClassBtn)

        noResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        noResultLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        noResultLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        

        
        noResultAddNewClassBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultAddNewClassBtn.topAnchor.constraint(equalTo: noResultLabel.bottomAnchor, constant: 20).isActive = true
        noResultAddNewClassBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        noResultAddNewClassBtn.rightAnchor.constraint(equalTo: view.leftAnchor, constant: -40).isActive = true
        noResultAddNewClassBtn.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        
        
        noResultAddNewClassBtn.setAttributedTitle(NSAttributedString(string: "Thêm Lớp Mới", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold), NSAttributedStringKey.foregroundColor: UIColor(red: 255/255, green: 158/255, blue: 0/255, alpha: 1.0)]), for: .normal)
        noResultAddNewClassBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultAddNewClassBtn.topAnchor.constraint(equalTo: noResultLabel.bottomAnchor, constant: 20).isActive = true
        noResultAddNewClassBtn.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        noResultAddNewClassBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        noResultAddNewClassBtn.addTarget(self, action: #selector(self.addNewClassDetailBtnPressed(_:)), for: .touchUpInside)
    }
    
    func updateTableviewVisibilityBasedOnSearchResult(){
        if(classDetails.count == 0){
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
