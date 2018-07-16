//
//  SchoolViewExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/14/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension SchoolViewController{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.searchTFUnderline.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
            self.searchUnderlineHeightAnchor?.constant = 2.5
        }, completion: nil)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            if textField.text == "" {
                self.searchTFUnderline.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 0.5)
                self.searchUnderlineHeightAnchor?.constant = 1.5
            }
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func updateTableviewVisibilityBasedOnSearchResult(){
        if(searchSchoolModels.count == 0){
            noResultLabel.isHidden = false
            noResultAddNewSchoolBtn.isHidden = false
            tableview.isHidden = true
        }
        else{
            noResultLabel.isHidden = true
            noResultAddNewSchoolBtn.isHidden = true
            tableview.isHidden = false
            tableview.reloadData()
        }
    }
    
    func customizeSearchTF(){
        view.addSubview(searchTFUnderline)
        searchTFUnderline.topAnchor.constraint(equalTo: searchTF.bottomAnchor).isActive = true
        searchUnderlineHeightAnchor = searchTFUnderline.heightAnchor.constraint(equalToConstant: 1.5)
        searchTFUnderline.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        searchTFUnderline.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        searchUnderlineHeightAnchor?.isActive = true
        searchTF.delegate = self
    }
    
    func setupNoResultLabelAndButton(topViewY:CGFloat, topViewHeight:CGFloat){
        
        let y = topViewY + topViewHeight + 40
        
        noResultLabel.frame = CGRect(x: 0, y: y, width: view.frame.width, height: 80)
        noResultLabel.text = "Không có kết quả. Bạn vui lòng điền có dấu. Bạn có muốn thêm tên trường?"
        noResultLabel.numberOfLines = 2
        
        noResultAddNewSchoolBtn.frame = CGRect(x: 0, y: y + 80, width: view.frame.width, height: 40)
        noResultAddNewSchoolBtn.setTitle("Thêm Trường Mới", for: .normal)
        noResultAddNewSchoolBtn.setTitleColor(UIColor.blue, for: .normal)
        
        noResultAddNewSchoolBtn.addTarget(self, action: #selector(self.addNewSchoolBtnPressed(_:)), for: .touchUpInside)
        
        view.addSubview(noResultLabel)
        view.addSubview(noResultAddNewSchoolBtn)
        
        view.bringSubview(toFront: noResultLabel)
        view.bringSubview(toFront: noResultAddNewSchoolBtn)
        
        view.layoutIfNeeded()
    }
    
}
