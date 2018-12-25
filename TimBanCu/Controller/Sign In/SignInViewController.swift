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

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var googleSignInBtn: GIDSignInButton!
    
    @IBAction func unwindToSignInViewController(segue:UIStoryboardSegue) { }
    
    private var controller: SignInController!
    private var uiController:SignInUIController!
    
    private var fbLoginBtn: LoginButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGoogleLogin()
        setupFacebookLogin()
        
        self.uiController = SignInUIController(viewController: self, facebookBtn: fbLoginBtn, googleBtn: googleSignInBtn)
        self.controller = SignInController()
        
        controller.loginSilently()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiController.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewDidLayoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        uiController.viewDidDisappear()
    }

}

// MARK: Google Sign In
extension SignInViewController:GIDSignInDelegate,GIDSignInUIDelegate{
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
        controller.handleGoogleSignIn(user: user, error: error) { [weak self] (uistate) in
            self?.uiController.state = uistate
        }
    }
    
    fileprivate func setupGoogleLogin(){
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
}

// MARK: Facebook Sign In
extension SignInViewController:LoginButtonDelegate{
    private func setupFacebookLogin(){
        fbLoginBtn = LoginButton(readPermissions: [ .publicProfile ])
        fbLoginBtn.delegate = self
    }
    
    //sign in with facebook
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        controller.handleFacebookSignIn { [weak self] (uiState) in
            self?.uiController.state = uiState
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print()
    }
}
