//
//  SettingTableViewExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/19/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

import GoogleSignIn

import FacebookCore
import FacebookLogin

import Firebase
import FirebaseAuth

extension SettingViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell") as? SettingTableViewCell
        cell?.settingLabel.text = settings[indexPath.row]
        cell?.settingImage.image = UIImage(named: icons[indexPath.row])
        cell?.selectedBackgroundView? = customSelectionColorView
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(settings[indexPath.row] == "Đăng Xuất"){
            GIDSignIn.sharedInstance().signOut()
            
            let loginManager = LoginManager()
            loginManager.logOut()
            
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            dismiss(animated: true, completion: nil)
        }
        else if(settings[indexPath.row] == "Sửa Thông Tin Cá Nhân"){
            if(!CurrentUserHelper.hasEnoughDataInFireBase()){
                print("No data to update")
            }
            
            performSegue(withIdentifier: "SettingsToChangeInfoSegue", sender: self)
        }
    }
}
