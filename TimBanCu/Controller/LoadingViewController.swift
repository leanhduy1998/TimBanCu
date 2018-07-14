//
//  LoadingViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/11/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

import GoogleSignIn

import FacebookCore
import FacebookLogin

import Firebase
import FirebaseDatabase

class LoadingViewController: UIViewController,GIDSignInDelegate, GIDSignInUIDelegate, LoginButtonDelegate {
    
    
    
    
    var schoolViewModels = [SchoolViewModel]()
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var googleSignInBtn: GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        GIDSignIn.sharedInstance().clientID = "137184194492-5iokn36749o7gmlodjnv6gskddjen7p1.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let facebookSignInBtn = LoginButton(readPermissions: [ .publicProfile ])
        
        facebookSignInBtn.frame = CGRect(x: view.bounds.width/2 - facebookSignInBtn.bounds.width/2, y: view.bounds.height - googleSignInBtn.bounds.height - facebookSignInBtn.bounds.height - 20-20, width: googleSignInBtn.bounds.width, height: googleSignInBtn.bounds.height)
        
        facebookSignInBtn.delegate = self
        
        view.addSubview(facebookSignInBtn)
        
        if let accessToken = AccessToken.current {
            print(accessToken.userId)
        }

        

    }
    
    
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            print(signIn.clientID)
            
            var di = [String:Any]()
            
            di = temp(t: "tieuhochanoi", di: di, id: signIn.clientID)
            di = temp(t: "tieuhoctphcm", di: di, id: signIn.clientID)
            di = temp(t: "thcshanoi", di: di, id: signIn.clientID)
            di = temp(t: "thcstanbinh", di: di, id: signIn.clientID)
            di = temp(t: "thpthanoi", di: di, id: signIn.clientID)
            di = temp(t: "thpttphcm", di: di, id: signIn.clientID)
            di = temp2(t: "dhcanuoc", di: di, id: signIn.clientID)
   
            self.ref.child("schools").setValue(di)
        }
       
    }
    
    func temp(t:String,di:[String:Any],id:String) -> [String:Any]{
        var di = di as? [String:Any]
        
        if let path = Bundle.main.path(forResource: t, ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                
                var name = ""
                var address = ""
                
                var x = 0
                
                while(x+2 < myStrings.count){
                    name = myStrings[x]
                    x=x+1
                    address = myStrings[x]
                    
                    print(name)
                    
                    name = name.replacingOccurrences(of: ".", with: " ", options: .literal, range: nil)
                    name = name.replacingOccurrences(of: "/", with: " ", options: .literal, range: nil)
                    
                    let dic = ["address":address,"type":"elementary","uid":id]
                    
                    di![name] = dic
                    
                    x=x+1
                }
                
            } catch {
                print(error)
            }
        }
        
        return di!
    }
    
    func temp2(t:String,di:[String:Any],id:String) -> [String:Any]{
        var di = di as? [String:Any]
        
        if let path = Bundle.main.path(forResource: t, ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                
                var name = ""
                
                var x = 0
                
                while(x+2 < myStrings.count){
                    name = myStrings[x]
                    
                    name = name.replacingOccurrences(of: ".", with: " ", options: .literal, range: nil)
                    name = name.replacingOccurrences(of: "/", with: " ", options: .literal, range: nil)
                    
                    print(name)
                    
                    let dic = ["address":"?","type":"elementary","uid":id]
                    
                    di![name] = dic
                    
                    x=x+1
                }
                
            } catch {
                print(error)
            }
        }
        
        return di!
    }
    
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print()
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if let destination = segue.destination as? SelectSchoolTypeViewController{
            destination.schoolViewModels = schoolViewModels
        }*/
        
        let navVC = segue.destination as? UINavigationController
        
        let destination = navVC?.viewControllers.first as! SelectSchoolTypeViewController
        
        destination.schoolViewModels = schoolViewModels
    }
    

}
