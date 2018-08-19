//
//  MajorExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/5/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension MajorViewController{
    
    func setUpAnimatedEmoticon() {
        view.addSubview(animatedEmoticon)
        animatedEmoticon.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        animatedEmoticon.heightAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.widthAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupNoResultLabelAndButton(){
        view.addSubview(noResultLabel)
        view.addSubview(noResultAddNewMajorBtn)
        
        noResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultLabel.topAnchor.constraint(equalTo: animatedEmoticon.bottomAnchor, constant: 20).isActive = true
        noResultLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        noResultLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        noResultAddNewMajorBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultAddNewMajorBtn.topAnchor.constraint(equalTo: noResultLabel.bottomAnchor, constant: 20).isActive = true
        noResultAddNewMajorBtn.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        noResultAddNewMajorBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        noResultAddNewMajorBtn.addTarget(self, action: #selector(self.addNewMajorBtnPressed(_:)), for: .touchUpInside)
    }
    
    func updateTableviewVisibilityBasedOnSearchResult(){
        if(searchMajors.count == 0){
            noResultLabel.isHidden = false
            noResultAddNewMajorBtn.isHidden = false
            tableview.isHidden = true
            animatedEmoticon.isHidden = false
            animatedEmoticon.play()
        }
        else{
            noResultLabel.isHidden = true
            noResultAddNewMajorBtn.isHidden = true
            tableview.isHidden = false
            tableview.reloadData()
            animatedEmoticon.isHidden = true
            animatedEmoticon.stop()
        }
    }
}
