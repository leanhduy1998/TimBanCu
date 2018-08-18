//
//  SettingViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/16/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

import GoogleSignIn

import FacebookCore
import FacebookLogin

import Firebase
import FirebaseAuth

class SettingViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var settings = ["Sửa Thông Tin Cá Nhân","Đăng Xuất"]
    var icons = ["edit", "signOut"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell") as? SettingTableViewCell
        cell?.settingLabel.text = settings[indexPath.row]
        cell?.settingImage.image = UIImage(named: icons[indexPath.row])
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
