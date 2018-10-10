//
//  UserImageUIController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 9/17/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import DropDown

class UserImageUIController{
    private weak var viewcontroller:UserImageViewController!
    private var optionDropDown = DropDown()
    private var yearLabel:UILabel!
    private var image:Image!
    private var imageview:UIImageView!
    private weak var optionBtn:UIButton!
    
    private var selectionClosure:SelectionClosure!
    
    var uiState:UIState = .DoNothing{
        willSet(newState){
            updateUIState(newState: newState)
        }
    }
    
    init(viewcontroller:UserImageViewController,selectionClosure:@escaping SelectionClosure){
        self.viewcontroller = viewcontroller
        self.yearLabel = viewcontroller.yearLabel
        self.image = viewcontroller.image
        self.imageview = viewcontroller.imageview
        self.selectionClosure = selectionClosure
        self.optionBtn = viewcontroller.optionBtn
        
        setupOptionDropdown()
        reloadYearLabelText()
        setupImageView()
    }
    
    private func updateUIState(newState:UIState){
        switch (uiState,newState) {
        case (.DoNothing,.DoNothing):
            break
        case (.DoNothing,.Success()):
            break
        case (.DoNothing,.Failure(let errStr)):
            let title = "Lỗi Kết Nối"
            let message =  errStr
            let alert = InfoAlert(title: title, message: message, alertType: .Error)
            alert.show(viewcontroller: viewcontroller)
            break

        default: fatalError("Not yet implemented \(uiState) to \(newState)")
        }
    }
    
    func showOptionDropdown(){
        optionDropDown.show()
    }
    
    func reloadYearLabelText(){
        if(image.year == nil){
            yearLabel.text = "Không Rõ Năm"
        }
        else{
            yearLabel.text = "Năm \(image.year!)"
        }
    }
    private func setupImageView(){
        imageview.image = image.image
    }
}

// DropDown
extension UserImageUIController{
    fileprivate func setupOptionDropdown(){
        if(image.uid != CurrentUser.getUid()){
            optionDropDown.isHidden = true
            optionBtn.isHidden = true
        }
        else{
            optionDropDown.isHidden = false
            optionBtn.isHidden = false
            
            optionDropDown.anchorView = viewcontroller.optionBtn
            optionDropDown.dataSource = ["Sửa Năm Hình","Xoá Hình"]
            optionDropDown.selectionAction = selectionClosure
        }
    }
}
