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

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    private var uiController:SettingUIController!

    override func viewDidLoad() {
        super.viewDidLoad()
        uiController = SettingUIController(viewcontroller: self)
    }
    
    func signOut(){
        GIDSignIn.sharedInstance().signOut()
        
        let loginManager = LoginManager()
        loginManager.logOut()
        
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        performSegue(withIdentifier: "SettingToSignInSegue", sender: self)
    }
}
