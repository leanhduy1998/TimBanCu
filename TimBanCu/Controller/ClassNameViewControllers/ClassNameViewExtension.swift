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
        
        noResultLabel.setConstraints(view: view, constraintTo: animatedEmoticon)
        
        noResultAddNewClassBtn.setContraints(view: view, contraintTo: noResultLabel)
        noResultAddNewClassBtn.addTarget(self, action: #selector(self.addNewClassDetailBtnPressed(_:)), for: .touchUpInside)
    }
    
    func setUpAnimatedEmoticon() {
        animatedEmoticon.contentMode = .scaleAspectFill
        animatedEmoticon.loopAnimation = true
        animatedEmoticon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animatedEmoticon)
        
        animatedEmoticon.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        animatedEmoticon.heightAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.widthAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func updateItemsVisibilityBasedOnSearchResult(){
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
    
    func hideItemsWhileFetchResult(){
        noResultLabel.isHidden = true
        noResultAddNewClassBtn.isHidden = true
        animatedEmoticon.isHidden = true
    }
    
}
