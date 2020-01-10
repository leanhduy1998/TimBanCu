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
    private var fbLoginBtn: LoginButton!
    @IBAction func unwindToSignInViewController(segue:UIStoryboardSegue) { }
    
    private var signInService: SignInService!
    
    
    private var revealingSplashView: RevealingSplashView! = nil
    private var appNameView: AnimateAppNameView!
    
    private var errorAlert = InfoAlert(title: "Đăng Nhập Không Thành Công", message: "", alertType: .Error)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleLogin()
        setupFacebookLogin()
        
        signInService = SignInService()
        signInService.loginSilently()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appNameView = AnimateAppNameView(viewController: self)
        appNameView.animate()
        view.bringSubview(toFront: appNameView)
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
        appNameView.remove()
    }
    
    private func goToNextScreen(){
        if(FirstTimeLaunch.getBool()){
            FirstTimeLaunch.setFalse()
            performSegue(withIdentifier: "SignInToEULASegue", sender: self)
        }
        else{
            performSegue(withIdentifier: "SignInToSelectSchoolTypeSegue", sender: self)
        }
    }
    
    private func render(newState: State) {
        switch(newState) {
        case .Success( _ ): goToNextScreen()
        case .Failure(let errorStr): createErrorAlert(errorStr: errorStr)
            // after login silently failed, aka, when the user is not log in google account
        default: break
        }
    }
    
    private func createErrorAlert(errorStr:String){
        errorAlert.changeMessage(message: errorStr)
        errorAlert.show(viewcontroller: self)
    }

}

// MARK: Setup
extension SignInViewController{
    private func setupInitialLoadingScreen() {
        revealingSplashView = HomeRevealingSplashView()
        view.addSubview(revealingSplashView!)
        revealingSplashView?.startAnimation()
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
        signInService.handleGoogleSignIn(user: user, error: error) { [weak self] (uistate) in
            guard let strongself = self else{
                return
            }
            strongself.render(newState: uistate)
        }
    }
    
    fileprivate func setupGoogleLogin(){
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        googleSignInBtn.style = GIDSignInButtonStyle.wide
    }
}

// MARK: Facebook Sign In
extension SignInViewController:LoginButtonDelegate{
    private func setupFacebookLogin(){
        fbLoginBtn = LoginButton(readPermissions: [ .publicProfile ])
        fbLoginBtn.delegate = self
        
        view.addSubview(fbLoginBtn)
        view.sendSubview(toBack: fbLoginBtn)
        
        fbLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        fbLoginBtn.bottomAnchor.constraint(equalTo: googleSignInBtn.topAnchor, constant: -10).isActive = true
        fbLoginBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fbLoginBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        fbLoginBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
    }
    
    //sign in with facebook
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        signInService.handleFacebookSignIn { [weak self] (uiState) in
            guard let strongself = self else{
                return
            }
            strongself.render(newState: uiState)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print()
    }
}
