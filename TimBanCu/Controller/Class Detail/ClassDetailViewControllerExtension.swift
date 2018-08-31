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
    
    //MARK: SetUp
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
        animatedEmoticon.contentMode = .scaleAspectFill
        animatedEmoticon.loopAnimation = true
        animatedEmoticon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animatedEmoticon)
        
        animatedEmoticon.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        animatedEmoticon.heightAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.widthAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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

    func setupNoResultLabel(){
        view.addSubview(noResultLabel)
   //     noResultLabel.setConstraints(view: view, constraintTo: animatedEmoticon)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.searchTFUnderline.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
            self.searchUnderlineHeightAnchor?.constant = 2.5
        }, completion: nil)

    }

}
