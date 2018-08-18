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
        noResultLabel.topAnchor.constraint(equalTo: animatedEmoticon.bottomAnchor, constant: 20).isActive = true
        noResultLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        noResultLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        noResultAddNewClassBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultAddNewClassBtn.topAnchor.constraint(equalTo: noResultLabel.bottomAnchor, constant: 20).isActive = true
        noResultAddNewClassBtn.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        noResultAddNewClassBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        noResultAddNewClassBtn.addTarget(self, action: #selector(self.addNewClassDetailBtnPressed(_:)), for: .touchUpInside)
    }
    
    func setUpAnimatedEmoticon() {
        view.addSubview(animatedEmoticon)
        animatedEmoticon.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        animatedEmoticon.heightAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.widthAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func updateTableviewVisibilityBasedOnSearchResult(){
        if(classDetails.count == 0){
            noResultLabel.isHidden = false
            noResultAddNewClassBtn.isHidden = false
            animatedEmoticon.isHidden = false
            animatedEmoticon.play()
            tableview.isHidden = true
            
        }
        else{
            noResultLabel.isHidden = true
            noResultAddNewClassBtn.isHidden = true
            animatedEmoticon.isHidden = true
            animatedEmoticon.stop()
            tableview.isHidden = false
            tableview.reloadData()
        }
    }
}
