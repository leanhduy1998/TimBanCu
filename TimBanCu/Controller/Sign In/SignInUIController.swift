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

class SignInUIController{
    
    var state: UIState = .Loading {
        willSet(newState) {
            update(newState: newState)
        }
    }
    
    var controller:UIViewController!
    
    
    
    var revealingSplashView: RevealingSplashView! = nil
    var shimmerAppNameLabel = ShimmeringLabel(textColor: themeColor)
    var appNameLabel:ShimmeringLabel! = nil
    
    var facebookBtn:LoginButton!
    var googleBtn:GIDSignInButton!
    
    
    init(viewController: UIViewController, facebookBtn:LoginButton, googleBtn:GIDSignInButton) {
        self.controller = viewController
        self.facebookBtn = facebookBtn
        self.googleBtn = googleBtn
        setUpSplashView()
        animateShimmeringText()
        setupFacebookBtn()
        setupGoogleButton()
    }
    
    func update(newState: UIState) {
        switch(state, newState) {
            
        case (.Loading, .Success( _ )): goToHome()
        case (.Loading, .Failure(let errorStr)): createErrorAlert(errorStr: errorStr)
            
        default: fatalError("Not yet implemented \(state) to \(newState)")
        }
    }
    
    func createErrorAlert(errorStr:String){
        let alert = InfoAlert.getAlert(title: "Đăng Nhập Không Thành Công", message: errorStr)
        controller.present(alert, animated: true, completion: nil)
    }
    
    func goToHome(){
        controller.performSegue(withIdentifier: "SignInToSelectSchoolTypeSegue", sender: self)
    }
    
    func setUpSplashView() {
        revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "Logo")!, iconInitialSize: CGSize(width: 140, height: 140), backgroundColor: UIColor(red:255/255, green:158/255, blue: 0, alpha:1.0))
        controller.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.popAndZoomOut
        revealingSplashView.startAnimation()
    }
    
    func animateShimmeringText() {
        appNameLabel = ShimmeringLabel(textColor: themeColor.withAlphaComponent(0.8))
        
        controller.view.addSubview(shimmerAppNameLabel)
        controller.view.addSubview(appNameLabel)
        
        let gradient = CAGradientLayer()
        gradient.frame = appNameLabel.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 0.5, 1]
        let angle = -60 * CGFloat.pi / 180
        gradient.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        shimmerAppNameLabel.layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 3.5
        animation.repeatCount = Float.infinity
        animation.autoreverses = false
        animation.fromValue = -controller.view.frame.width
        animation.toValue = controller.view.frame.width
        gradient.add(animation, forKey: "shimmerKey")
    }
    
    func setupFacebookBtn(){
        facebookBtn.translatesAutoresizingMaskIntoConstraints = false
        
        controller.view.addSubview(facebookBtn)
        controller.view.sendSubview(toBack: facebookBtn)
        facebookBtn.bottomAnchor.constraint(equalTo: googleBtn.topAnchor, constant: -10).isActive = true
        facebookBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        facebookBtn.leftAnchor.constraint(equalTo: controller.view.leftAnchor, constant: 40).isActive = true
        facebookBtn.rightAnchor.constraint(equalTo: controller.view.rightAnchor, constant: -40).isActive = true
    }
    
    func setupGoogleButton(){
        
        googleBtn.style = GIDSignInButtonStyle.wide
    }
    
}
