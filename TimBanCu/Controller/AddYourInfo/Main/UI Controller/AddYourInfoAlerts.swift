//
//  AddYourInfoAlert.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/25/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class AddYourInfoAlerts{
    
    private weak var viewcontroller:UIViewController!
    private var addImageYearAlert:AskForInputAlert!
    private var privacyAlert:InfoAlert!
    private var noProfileImageAlert:InfoAlert!
    private var uploadErrorAlert:InfoAlert!
    
    init(viewcontroller:UIViewController){
        self.viewcontroller = viewcontroller
        setupAddImageYearAlert()
        setupPrivacyAlert()
        setupNoProfileImageAlert()
        setupUploadErrorAlert()
    }
    
    func showPrivacyAlert(){
        privacyAlert.show(viewcontroller: viewcontroller)
    }
    func showAddNewImageYearAlert(){
        addImageYearAlert.show(viewcontroller: viewcontroller)
    }
    func showNoProfileImageAlert(){
        noProfileImageAlert.show(viewcontroller: viewcontroller)
    }
    func showUploadErrorAlert(errMsg:String){
        uploadErrorAlert.changeMessage(message: errMsg)
        uploadErrorAlert.show(viewcontroller: viewcontroller)
    }
    
    private func setupUploadErrorAlert(){
        let title = "Lỗi Cập Nhật Thông Tin"
        let mesage = "Bạn Vui Lòng Thử Lại"
        
        uploadErrorAlert = InfoAlert(title: title, message: mesage, alertType: .Error)
    }
    
    private func setupNoProfileImageAlert(){
        let title = "Thiếu Hình Cá Nhân"
        let message = "Bạn hãy thêm ít nhất 1 hình cá nhân. Bạn có thể thêm nhiều hình tại nhiều năm khác nhau để các bạn khác dễ nhận diện."
        
        noProfileImageAlert = InfoAlert(title: title, message: message, alertType: .MissingImage)
    }
    
    private func setupPrivacyAlert(){
        let title = "Mức Công Khai Thông Tin"
        let message = "Bạn có thể chọn chia sẻ thông tin của mình công khai hoặc chỉ mình bạn. Nếu không công khai, người dùng khác sẽ phải được sự đồng ý của bạn trước khi xem thông tin đó."
        privacyAlert = InfoAlert(title: title, message: message, alertType: .Info)
    }
    
    private func setupAddImageYearAlert(){
        let title = "Bạn Nên Thêm Năm Hình Này Được Chụp!"
        let message = "Mọi người sẽ dễ nhận diện bạn hơn!"
        let textFieldPlaceHolder = "Năm Hình Được Chụp"
        
        addImageYearAlert = AskForInputAlert(title: title, message: message, textFieldPlaceHolder: textFieldPlaceHolder)
        addImageYearAlert.setTextFieldKeyboardType(type: .numberPad)
        
        
        // Add btn pressed
        addImageYearAlert.addAction(actionTitle: "Thêm") { (_) in
            
        }
    }
}
