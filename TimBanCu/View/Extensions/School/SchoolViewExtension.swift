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
            self.searchTFUnderline.backgroundColor = themeColor.withAlphaComponent(0.7)
            self.searchUnderlineHeightAnchor?.constant = 2.5
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            if textField.text == "" {
                self.searchTFUnderline.backgroundColor = themeColor.withAlphaComponent(0.4)
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
            animatedEmoticon.isHidden = false
            animatedEmoticon.play()
            tableview.isHidden = true
        }
        else{
            noResultLabel.isHidden = true
            noResultAddNewSchoolBtn.isHidden = true
            animatedEmoticon.isHidden = true
            animatedEmoticon.stop()
            tableview.isHidden = false
            tableview.reloadData()
            
        }
    }
    
    func setUpAnimatedEmoticon() {
        view.addSubview(animatedEmoticon)
        animatedEmoticon.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        animatedEmoticon.heightAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.widthAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func customizeSearchTF(){
        view.addSubview(searchTFUnderline)
        searchTFUnderline.topAnchor.constraint(equalTo: searchTF.bottomAnchor, constant: 8).isActive = true
        searchUnderlineHeightAnchor = searchTFUnderline.heightAnchor.constraint(equalToConstant: 1.5)
        searchTFUnderline.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        searchTFUnderline.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        searchUnderlineHeightAnchor?.isActive = true
        searchTF.delegate = self
    }
    
    func setupNoResultLabelAndButton(){
        view.addSubview(noResultLabel)
        view.addSubview(noResultAddNewSchoolBtn)
        
        view.bringSubview(toFront: noResultLabel)
        view.bringSubview(toFront: noResultAddNewSchoolBtn)

        noResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultLabel.topAnchor.constraint(equalTo: animatedEmoticon.bottomAnchor, constant: 20).isActive = true
        noResultLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        noResultLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        noResultAddNewSchoolBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultAddNewSchoolBtn.topAnchor.constraint(equalTo: noResultLabel.bottomAnchor, constant: 20).isActive = true
        noResultAddNewSchoolBtn.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        noResultAddNewSchoolBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        noResultAddNewSchoolBtn.addTarget(self, action: #selector(self.addNewSchoolBtnPressed(_:)), for: .touchUpInside)
    }
    
}
