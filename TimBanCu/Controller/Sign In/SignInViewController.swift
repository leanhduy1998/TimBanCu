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

import Firebase
import FirebaseDatabase
import FirebaseAuth

import RevealingSplashView

class SignInViewController: UIViewController,GIDSignInDelegate, GIDSignInUIDelegate, LoginButtonDelegate, UITextFieldDelegate {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var googleSignInBtn: GIDSignInButton!
    
    var signInAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    
    var revealingSplashView: RevealingSplashView! = nil
    
    var shimmerAppNameLabel: ShimmeringLabel! = nil
    var appNameLabel: ShimmeringLabel! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        setUpSplashView()
        setupFacebookBtn()
        setupGoogleButton()
        animateShimmeringText()
        
        signInAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
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
            

            guard let authentication = user.authentication else { return }
        
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            
            firebaseSignIn(credential: credential) { (success) in
                if(success){
                    let uid = Auth.auth().currentUser?.uid
                    
                    self.loadUserInfo(uid: uid!) {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "SignInToSelectSchoolTypeSegue", sender: self)
                        }
                    }
                    
                }
            }
        }
        else{
            signInAlert.title = "Google Sign In Error"
            signInAlert.message = error.localizedDescription
            present(signInAlert, animated: true, completion: nil)
        }
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        if let accessToken = AccessToken.current {
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
            
            firebaseSignIn(credential: credential) { (success) in
                if(success){
                    let uid = accessToken.userId
                    
                    self.loadUserInfo(uid: uid!) {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "SignInToSelectSchoolTypeSegue", sender: self)
                        }
                    }
                    
                }
            }

        }
        else{
            signInAlert.title = "Facebook Sign In Error"
            signInAlert.message = "Error"
            present(signInAlert, animated: true, completion: nil)
        }
    }
    
    func firebaseSignIn(credential:AuthCredential, completionHandler: @escaping (_ success:Bool) -> Void){
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self.signInAlert.title = "Sign In With Database Error"
                    self.signInAlert.message = error.localizedDescription
                    self.present(self.signInAlert, animated: true, completion: nil)
                    completionHandler(false)
                    return
                }
                // User is signed in
                completionHandler(true)
            }
        }
    }
    
    func loadUserInfo(uid:String, completionHandler: @escaping () -> Void){
        AllUserHelper.getAnyStudentFromDatabase(uid: uid) { (student) in
            
            CurrentUserHelper.setStudent(student: student)
            
            completionHandler()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print()
    }
}
