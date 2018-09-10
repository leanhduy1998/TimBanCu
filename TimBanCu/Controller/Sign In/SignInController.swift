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



protocol SignInDelegate: class {
    var state: UIState { get set}
}

final class SignInController{
    var state: UIState = .Loading {
        willSet(newState) {
            update(newState: newState)
        }
    }
    
    var uid:String!
    
    func update(newState: UIState) {
        
        switch(state, newState) {
            
        case (.Loading, .Success()): loadUserInfo()
        case (.Success(), .Success()): break
            
        default: fatalError("Not yet implemented \(state) to \(newState)")
        }
    }
    
    func loadUserInfo(){
        AllUserHelper.getAnyStudentFromDatabase(uid: uid) { (student) in
            CurrentUser.setStudent(student: student)
        }
    }
    
    func signIn(credential:AuthCredential, completionHandler: @escaping (_ uiState:UIState) -> Void){
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(.Failure(error.localizedDescription))
                }
                
                self.uid = Auth.auth().currentUser?.uid
                // User is signed in
                completionHandler(.Success())
            }
        }
    }
}

