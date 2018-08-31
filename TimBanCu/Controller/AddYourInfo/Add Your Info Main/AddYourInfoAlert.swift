//
//  AddYourInfoAlert.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/25/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension AddYourInfoViewController{
    func setupAlerts(){
        setupAddImageYearAlert()
        setupPrivacyAlert()
    }
    
    func setupPrivacyAlert(){
        let title = "Mức Công Khai Thông Tin"
        let message = "Bạn có thể chọn chia sẻ thông tin của mình công khai hoặc chỉ mình bạn. Nếu không công khai, người dùng khác sẽ phải được sự đồng ý của bạn trước khi xem thông tin đó."
        
       // privacyAlert = InfoAlert.getAlert(title: title, message: message)
    }
    
    func setupAddImageYearAlert(){
        addImageYearAlert = UIAlertController(title: "Bạn Nên Thêm Năm Hình Này Được Chụp!", message: "Mọi người sẽ dễ nhận diện bạn hơn!", preferredStyle: .alert)
        
        addImageYearAlert.addTextField { (textField) in
            textField.placeholder = "Năm Hình Được Chụp"
            textField.keyboardType = .numberPad
        }
        
        addImageYearAlert.addAction(UIAlertAction(title: "Thêm", style: .default, handler: { [weak addImageYearAlert] (_) in
            let textField = addImageYearAlert?.textFields![0] // Force unwrapping because we know it exists.
            let year = Int((textField?.text)!)
            self.yearOfUserImage[self.selectedImage] = year
            
            self.reloadYearLabel(page: self.imageSlideShow.currentPage)
        }))
        
        addImageYearAlert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { [weak addImageYearAlert] (_) in
            
        }))
    }
}
