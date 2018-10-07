//
//  SignInViewController
//  TimBanCu
//
//  Created by Duy Le 2 on 7/11/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

import GoogleSignIn

import FacebookCore
import FacebookLogin
import FBSDKLoginKit

import Firebase
import FirebaseDatabase
import FirebaseAuth

import RevealingSplashView

class SignInViewController: UIViewController,GIDSignInDelegate, GIDSignInUIDelegate, LoginButtonDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var googleSignInBtn: GIDSignInButton!
    
    var signInController: SignInController!
    var signInUIController:SignInUIController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let fbLoginBtn = LoginButton(readPermissions: [ .publicProfile ])
        fbLoginBtn.delegate = self
        
        self.signInUIController = SignInUIController(viewController: self, facebookBtn: fbLoginBtn, googleBtn: googleSignInBtn)
        self.signInController = SignInController()
        
        if let accessToken = AccessToken.current {
            // User is logged in, use 'accessToken' here.
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
            
            signInController.signIn(credential: credential) { (state) in
                self.signInController.state = state
                self.signInUIController.state = state
            }
        }
        GIDSignIn.sharedInstance()?.signInSilently()
        
        //GIDSignIn.sharedInstance()?.signIn()

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
    
    // sign in with google
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            guard let authentication = user.authentication else { return }
        
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            
            signInController.signIn(credential: credential) { (state) in
                self.signInController.state = state
                self.signInUIController.state = state
            }
        }
        else{
            self.signInUIController.state = .Failure(error.localizedDescription)
        }
    }
    
    //sign in with facebook
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        if let accessToken = AccessToken.current {
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
            
            signInController.signIn(credential: credential) { (state) in
                self.signInController.state = state
                self.signInUIController.state = state
            }

        }
        else{
            self.signInUIController.state = .Failure("Lỗi Đăng Nhập Facebook")
        }
    }
    
  
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print()
    }

}
