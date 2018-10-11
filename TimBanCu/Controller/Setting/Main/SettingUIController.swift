//
//  SettingUIController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 10/9/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit


class SettingUIController{
    private weak var viewcontroller:SettingViewController!
    
    private var genericTableView:GenericTableView<Setting.SettingEnum, SettingTableViewCell>!
    private let customSelectionColorView = CustomSelectionColorView()
    

    init(viewcontroller:SettingViewController){
        self.viewcontroller = viewcontroller
        viewcontroller.addNavigationBarShadow()
        
        genericTableView = GenericTableView(tableview: viewcontroller.tableview, items: Setting.getAllSettings()) { [weak self] (cell, setting) in
            cell.settingLabel.text = setting.getString()
            cell.settingImage.image = setting.getIconName()
            cell.selectedBackgroundView? = (self?.customSelectionColorView)!
        }
        
        genericTableView.didSelect = { (setting) in
            switch(setting){
            case .SignOut:
                viewcontroller.signOut()
                break
            case .Edit:
                if(!CurrentUser.hasEnoughDataInFireBase()){
                    viewcontroller.performSegue(withIdentifier: "SettingToNoUserInfoSegue", sender: self)
                }
                else{
                    viewcontroller.performSegue(withIdentifier: "SettingsToUpdateInfoSegue", sender: self)
                }
                break
            }
        }
    }
}
