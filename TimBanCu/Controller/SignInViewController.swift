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

class SignInViewController: UIViewController,GIDSignInDelegate, GIDSignInUIDelegate, LoginButtonDelegate {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var googleSignInBtn: GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        GIDSignIn.sharedInstance().clientID = "137184194492-5iokn36749o7gmlodjnv6gskddjen7p1.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        googleSignInBtn.style = GIDSignInButtonStyle.wide
        
        let facebookSignInBtn = LoginButton(readPermissions: [ .publicProfile ])
        facebookSignInBtn.delegate = self
        facebookSignInBtn.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(facebookSignInBtn)
        facebookSignInBtn.bottomAnchor.constraint(equalTo: googleSignInBtn.topAnchor, constant: -20).isActive = true
        facebookSignInBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        facebookSignInBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        facebookSignInBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        
        
        
        
        
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
            AuthHelper.uid = signIn.clientID
            
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if let error = error {
                    // ...
                    return
                }
                // User is signed in
                 self.performSegue(withIdentifier: "SignInToSelectSchoolTypeSegue", sender: self)
            }
            
           
        }
       
    }
    
    
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        if let accessToken = AccessToken.current {
            AuthHelper.uid = accessToken.userId
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if let error = error {
                    // ...
                    return
                }
                // User is signed in
                self.performSegue(withIdentifier: "SignInToSelectSchoolTypeSegue", sender: self)
            }
            
        }
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
    }
    

}
