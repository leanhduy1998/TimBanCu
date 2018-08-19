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
        privacyAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak privacyAlert] (_) in
            privacyAlert?.dismiss(animated: true, completion: nil)
        }))
    }
    
    func setupAddImageYearAlert(){
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
