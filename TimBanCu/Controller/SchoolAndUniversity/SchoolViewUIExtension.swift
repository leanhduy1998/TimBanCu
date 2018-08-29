//
//  SchoolViewExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/14/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import Lottie

extension SchoolViewController{
    

    func setUpTableView() {
        tableview.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tableview.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        tableview.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func setUpAnimatedEmoticon() {
        animatedEmoticon = LOTAnimationView(name: "empty_list")
        animatedEmoticon.contentMode = .scaleAspectFill
        animatedEmoticon.loopAnimation = true
        animatedEmoticon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animatedEmoticon)
        
        animatedEmoticon.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        animatedEmoticon.heightAnchor.constraint(equalToConstant: 150).isActive = true
       animatedEmoticon.widthAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupNoResultLabelAndButton(){
        view.addSubview(noResultLabel)
        view.addSubview(noResultAddNewSchoolBtn)

        noResultLabel.setConstraints(view: view, constraintTo: animatedEmoticon)
        
        noResultAddNewSchoolBtn.setContraints(view: view, contraintTo: noResultLabel)
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
    
    func hideItemsWhileFetchingData(){
        noResultLabel.isHidden = true
        noResultAddNewSchoolBtn.isHidden = true
        tableview.isHidden = false
        
        animatedEmoticon.isHidden = true
    }
    
}
