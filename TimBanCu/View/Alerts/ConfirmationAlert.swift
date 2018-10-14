//
//  ConfirmationAlert.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/10/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class  ConfirmationAlert{    
    let alert:UIAlertController!
    
    init(title:String,message:String, confirmed:@escaping ()->()){
        alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Đồng Ý", style: .default, handler: { (_) in
            confirmed()
        }))
        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { [weak self] (_) in
            self!.alert.dismiss(animated: true, completion: nil)
        }))
    }
    
    func showAlert(viewcontroller:UIViewController){
        viewcontroller.present(alert, animated: true, completion: nil)
    }
}
