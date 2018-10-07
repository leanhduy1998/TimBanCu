//
//  SettingViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/16/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit



class SettingViewController: UIViewController {
    
    var settings = ["Sửa Thông Tin Cá Nhân","Đăng Xuất"]
    var icons = ["edit", "signOut"]
    
    var finishedLoadingInitialTableCells = false
    
    let customSelectionColorView = CustomSelectionColorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        finishedLoadingInitialTableCells = false
    }
    
}
