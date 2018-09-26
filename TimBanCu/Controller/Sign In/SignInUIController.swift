//
//  SignInUIController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/28/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import RevealingSplashView
import FacebookCore
import FacebookLogin
import GoogleSignIn

final class SignInUIController{
    
    var state: UIState = .Loading {
        willSet(newState) {
            update(newState: newState)
        }
    }
    
    private weak var viewcontroller:SignInViewController!
    
    private var revealingSplashView: RevealingSplashView! = nil
    
    private var facebookBtn:LoginButton!
    private var googleBtn:GIDSignInButton!
    
    private var errorAlert:InfoAlert!
    private var animateAppName: AnimateAppName!
    
    init(viewController: SignInViewController, facebookBtn:LoginButton, googleBtn:GIDSignInButton) {
        self.viewcontroller = viewController
        self.facebookBtn = facebookBtn
        self.googleBtn = googleBtn
        
        self.animateAppName = AnimateAppName(viewController: viewcontroller)
        
        setUpSplashView()
        setupFacebookBtn()
        setupGoogleButton()
        
        errorAlert = InfoAlert(title: "Đăng Nhập Không Thành Công", message: "")
    }

    private func update(newState: UIState) {
        switch(state, newState) {
            
        case (.Loading, .Success( _ )): goToHome()
        case (.Loading, .Failure(let errorStr)): createErrorAlert(errorStr: errorStr)
        case (.Success( _ ), .Success( _ )):break
            
        default: fatalError("Not yet implemented \(state) to \(newState)")
        }
    }
    
    private func createErrorAlert(errorStr:String){
        errorAlert.changeMessage(message: errorStr)
        errorAlert.show(viewcontroller: viewcontroller)
    }
    
    private func goToHome(){
        viewcontroller.performSegue(withIdentifier: "SignInToSelectSchoolTypeSegue", sender: self)
    }
    
    private func setUpSplashView() {
        revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "Logo")!, iconInitialSize: CGSize(width: 140, height: 140), backgroundColor: UIColor(red:255/255, green:158/255, blue: 0, alpha:1.0))
        viewcontroller.view.addSubview(revealingSplashView!)
        revealingSplashView?.animationType = SplashAnimationType.popAndZoomOut
        revealingSplashView?.startAnimation()
    }
    
    private func setupFacebookBtn(){
        viewcontroller.view.addSubview(facebookBtn)
        viewcontroller.view.sendSubview(toBack: facebookBtn)
        
        facebookBtn.translatesAutoresizingMaskIntoConstraints = false
        facebookBtn.bottomAnchor.constraint(equalTo: googleBtn.topAnchor, constant: -10).isActive = true
        facebookBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        facebookBtn.leftAnchor.constraint(equalTo: viewcontroller.view.leftAnchor, constant: 40).isActive = true
        facebookBtn.rightAnchor.constraint(equalTo: viewcontroller.view.rightAnchor, constant: -40).isActive = true
    }
    
    private func setupGoogleButton(){
        googleBtn.style = GIDSignInButtonStyle.wide
    }
    
}
