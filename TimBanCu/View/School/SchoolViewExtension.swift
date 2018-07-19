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
        searchTFUnderline = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0).withAlphaComponent(0.5)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        view.addSubview(searchTFUnderline)
        searchTFUnderline.topAnchor.constraint(equalTo: searchTF.bottomAnchor).isActive = true
        searchUnderlineHeightAnchor = searchTFUnderline.heightAnchor.constraint(equalToConstant: 1.5)
        searchTFUnderline.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        searchTFUnderline.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        searchUnderlineHeightAnchor?.isActive = true
        searchTF.delegate = self
    }
    
    func setupNoResultLabelAndButton(){
        view.addSubview(noResultLabel)
        view.addSubview(noResultAddNewSchoolBtn)
        
<<<<<<< HEAD:TimBanCu/View/School/SchoolViewExtension.swift
        view.bringSubview(toFront: noResultLabel)
        view.bringSubview(toFront: noResultAddNewSchoolBtn)
        
        noResultLabel.text = "n"
        noResultLabel.textColor = UIColor.darkGray
        noResultLabel.textAlignment = .center
        noResultLabel.numberOfLines = 2
        noResultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        noResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultLabel.topAnchor.constraint(equalTo: searchTF.bottomAnchor, constant: 80).isActive = true
        noResultLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        noResultLabel.rightAnchor.constraint(equalTo: view.leftAnchor, constant: -40).isActive = true
        noResultLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
=======
        noResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        noResultLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        noResultLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
>>>>>>> UI-Design:TimBanCu/View/SchoolViewExtension.swift
        
        noResultAddNewSchoolBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultAddNewSchoolBtn.topAnchor.constraint(equalTo: noResultLabel.bottomAnchor, constant: 20).isActive = true
        noResultAddNewSchoolBtn.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        noResultAddNewSchoolBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        noResultAddNewSchoolBtn.addTarget(self, action: #selector(self.addNewSchoolBtnPressed(_:)), for: .touchUpInside)
    }
    
}
