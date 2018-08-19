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

        noResultLabel.setConstraints(view: view, animatedEmoticon: animatedEmoticon)

        
        noResultAddNewSchoolBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultAddNewSchoolBtn.topAnchor.constraint(equalTo: noResultLabel.bottomAnchor, constant: 20).isActive = true
        noResultAddNewSchoolBtn.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        noResultAddNewSchoolBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        noResultAddNewSchoolBtn.addTarget(self, action: #selector(self.addNewSchoolBtnPressed(_:)), for: .touchUpInside)
    }
    
    func updateUIFromData(){
        DispatchQueue.main.async {
            self.searchSchoolModels = self.schoolModels
            self.tableview.reloadData()
            self.updateItemsVisibilityBasedOnSearchResult()
        }
    }
    
    func updateItemsVisibilityBasedOnSearchResult(){
        if(searchSchoolModels.count == 0){
            noResultLabel.isHidden = false
            noResultAddNewSchoolBtn.isHidden = false
            tableview.isHidden = true
            
            animatedEmoticon.isHidden = false
            animatedEmoticon.play()
        }
        else{
            noResultLabel.isHidden = true
            noResultAddNewSchoolBtn.isHidden = true
            tableview.isHidden = false
            
            animatedEmoticon.isHidden = true
            animatedEmoticon.stop()
        }
    }
    
}
