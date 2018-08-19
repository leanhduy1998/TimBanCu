//
//  ClassDetailViewControllerExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/17/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension ClassDetailViewController{
    override func viewDidLayoutSubviews() {
        setupNoResultLabel(topViewY: searchTF.bounds.origin.y, topViewHeight: searchTF.frame.height)
        view.layoutIfNeeded()
    }
    
    func customizeSearchTF() {
        view.addSubview(searchTFUnderline)
        searchTFUnderline.topAnchor.constraint(equalTo: searchTF.bottomAnchor, constant: 8).isActive = true
        searchUnderlineHeightAnchor = searchTFUnderline.heightAnchor.constraint(equalToConstant: 1.5)
        searchTFUnderline.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        searchTFUnderline.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        searchUnderlineHeightAnchor?.isActive = true
        searchTF.delegate = self
    }
    
    func setUpAnimatedEmoticon() {
        view.addSubview(animatedEmoticon)
        animatedEmoticon.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        animatedEmoticon.heightAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.widthAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    
    func setupNoResultLabel(topViewY:CGFloat, topViewHeight:CGFloat){
        view.addSubview(noResultLabel)
        view.bringSubview(toFront: noResultLabel)
        
        noResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultLabel.topAnchor.constraint(equalTo: animatedEmoticon.bottomAnchor, constant: 20).isActive = true
        noResultLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        noResultLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func updateTableviewVisibilityBasedOnSearchResult(){
        if(searchStudents.count == 0){
            noResultLabel.isHidden = false
            tableview.isHidden = true
            animatedEmoticon.isHidden = false
            animatedEmoticon.play()
        }
        else{
            noResultLabel.isHidden = true
            tableview.isHidden = false
            animatedEmoticon.isHidden = true
            animatedEmoticon.stop()
        }
    }
    
    func startLoading(){
        tableview.isHidden = true
        searchTF.isHidden = true
        addYourselfBtn.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopLoading(){
        UIView.animate(withDuration: 1) {
            self.tableview.isHidden = false
            self.searchTF.isHidden = false
            self.activityIndicator.isHidden = true
        }
        activityIndicator.stopAnimating()
    }
    
    
}
