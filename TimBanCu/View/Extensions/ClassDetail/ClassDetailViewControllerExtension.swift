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
    
    func setupNoResultLabel(topViewY:CGFloat, topViewHeight:CGFloat){
        view.addSubview(noResultLabel)
        view.bringSubview(toFront: noResultLabel)
        
        noResultLabel.text = "Chưa có học sinh nào. Bạn có muốn thông tin của mình?"
        noResultLabel.textColor = UIColor.darkGray
        noResultLabel.textAlignment = .center
        noResultLabel.numberOfLines = 2
        noResultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        noResultLabel.frame = CGRect(x: 0, y: 40, width: view.bounds.width, height: 40)
        
    }
    
    func updateTableviewVisibilityBasedOnSearchResult(){
        if(searchStudents.count == 0){
            noResultLabel.isHidden = false
            tableview.isHidden = true
        }
        else{
            noResultLabel.isHidden = true
            tableview.isHidden = false
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
