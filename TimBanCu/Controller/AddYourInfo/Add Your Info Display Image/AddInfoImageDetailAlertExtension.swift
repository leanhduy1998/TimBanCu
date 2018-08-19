//
//  AddInfoImageDetailAlertExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/19/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension AddInfoImageDetailViewController{
    func setupAlert(){
        let title = "Sửa Năm Hình Này Được Chụp!"
        let message = ""
        
        editImageYearAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        editImageYearAlert.addTextField { (textField) in
            textField.placeholder = "Năm Hình Được Chụp"
            textField.keyboardType = .numberPad
        }
        
        editImageYearAlert.addAction(UIAlertAction(title: "Sửa Năm", style: .default, handler: { [weak editImageYearAlert] (_) in
            let textField = editImageYearAlert?.textFields![0] // Force unwrapping because we know it exists.
            let year = Int((textField?.text)!)
            self.yearOfUserImage[self.userImages[self.indexForDeletion]] = year
            self.performSegue(withIdentifier: "unwindToAddYourInfoControllerWithSegue", sender: self)
        }))
    }
}
