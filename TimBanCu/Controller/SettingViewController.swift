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
    
    var finishedLoadingInitialTableCells = false
    
    let customSelectionColorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0, alpha: 0.2)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        finishedLoadingInitialTableCells = false
    }

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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //1. Setup the CATransform3D structure
        
        var rotation = CATransform3D()
        
        rotation = CATransform3DMakeRotation((90.0 * .pi) / 180, 0.0, 0.7, 0.4)
        
        rotation.m34 = 1.0 / -600
        
        //2. Define the initial state (Before the animation)
        
        cell.layer.shadowColor = UIColor.black.cgColor
        
        cell.layer.shadowOffset = CGSize(width: CGFloat(10), height: CGFloat(10))
        
        cell.alpha = 0
        
        cell.layer.transform = rotation
        
        cell.layer.anchorPoint = CGPoint(x: CGFloat(0), y: CGFloat(0.5))
        
        //!!!FIX for issue #1 Cell position wrong————
        
        if cell.layer.position.x != 0 {
            
            cell.layer.position = CGPoint(x: CGFloat(0), y: CGFloat(cell.layer.position.y))
            
        }
        
        //4. Define the final state (After the animation) and commit the animation
        
        UIView.beginAnimations("rotation", context: nil)
        
        UIView.setAnimationDuration(0.8)
        
        cell.layer.transform = CATransform3DIdentity
        
        cell.alpha = 1
        
        cell.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(0))
        
        UIView.commitAnimations()
        
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
