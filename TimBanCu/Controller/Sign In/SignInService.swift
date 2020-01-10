//
//  SignInController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/28/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import GoogleSignIn
import FirebaseAuth

import FacebookCore
import FacebookLogin
import FBSDKLoginKit

final class SignInService{
    
    var uid:String!
    
    private func loadUserInfo(){
        
        FirebaseDownloader.shared.getStudent(with: uid) { (student) in
            if(student != nil){
                CurrentUser.student = student
            }
        }
    }
    
    func loginSilently(){
        if let accessToken = AccessToken.current {
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
            
            firebaseSignIn(credential: credential)
        }
        GIDSignIn.sharedInstance()?.signInSilently()
    }
    
    func handleGoogleSignIn(user: GIDGoogleUser!, error: Error!,completionHandler: @escaping (_ state:State) -> Void){
        if (error == nil) {
            guard let authentication = user.authentication else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            
            firebaseSignIn(credential: credential, completionHandler: completionHandler)
        }
        else{
            completionHandler(.Failure(error.debugDescription))
        }
    }
    
    func handleFacebookSignIn(completionHandler: @escaping (_ state:State) -> Void){
        if let accessToken = AccessToken.current {
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
            
            firebaseSignIn(credential: credential, completionHandler: completionHandler)
        }
        else{
            completionHandler(.Failure("Lỗi Đăng Nhập Facebook"))
        }
    }
    
    private func firebaseSignIn(credential:AuthCredential, completionHandler: @escaping (_ state:State) -> Void){
        Auth.auth().signInAndRetrieveData(with: credential) { [weak self] (authResult, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(.Failure(error.localizedDescription))
                }
                
                self?.uid = Auth.auth().currentUser?.uid
                self?.loadUserInfo()
                completionHandler(.Success(nil))
            }
        }
    }
    
    private func firebaseSignIn(credential:AuthCredential){
        firebaseSignIn(credential: credential) { (_) in}
    }
}

