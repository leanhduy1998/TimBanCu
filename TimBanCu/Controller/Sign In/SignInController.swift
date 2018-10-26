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

final class SignInController{
    
    var uid:String!
    
    private func loadUserInfo(){
        Student.getFromDatabase(withUid: uid) { (student) in
            CurrentUser.student = student
        }
    }
    
    func loginSilently(){
        if let accessToken = AccessToken.current {
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
            
            firebaseSignIn(credential: credential)
        }
        GIDSignIn.sharedInstance()?.signInSilently()
    }
    
    func handleGoogleSignIn(user: GIDGoogleUser!, error: Error!,completionHandler: @escaping (_ uiState:UIState) -> Void){
        if (error == nil) {
            guard let authentication = user.authentication else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            
            firebaseSignIn(credential: credential, completionHandler: completionHandler)
        }
        else{
            completionHandler(.Failure(error.debugDescription))
        }
    }
    
    func handleFacebookSignIn(completionHandler: @escaping (_ uiState:UIState) -> Void){
        if let accessToken = AccessToken.current {
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
            
            firebaseSignIn(credential: credential, completionHandler: completionHandler)
        }
        else{
            completionHandler(.Failure("Lỗi Đăng Nhập Facebook"))
        }
    }
    
    private func firebaseSignIn(credential:AuthCredential, completionHandler: @escaping (_ uiState:UIState) -> Void){
        Auth.auth().signInAndRetrieveData(with: credential) { [weak self] (authResult, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(.Failure(error.localizedDescription))
                }
                
                self?.uid = Auth.auth().currentUser?.uid
                
                self?.loadUserInfo()
                
                completionHandler(.Success())
            }
        }
    }
    
    private func firebaseSignIn(credential:AuthCredential){
        Auth.auth().signInAndRetrieveData(with: credential) { [weak self] (authResult, error) in
            DispatchQueue.main.async {
                self?.uid = Auth.auth().currentUser?.uid
                self?.loadUserInfo()
            }
        }
    }
}

