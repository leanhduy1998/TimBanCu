//
//  SignInExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/26/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore
import FacebookLogin
import GoogleSignIn
import RevealingSplashView

extension SignInViewController{
    
    func setUpSplashView() {
        revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "Logo")!, iconInitialSize: CGSize(width: 140, height: 140), backgroundColor: UIColor(red:255/255, green:158/255, blue: 0, alpha:1.0))
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.popAndZoomOut
        revealingSplashView.startAnimation()
    }
    
    func setupFacebookBtn(){
        let facebookSignInBtn = LoginButton(readPermissions: [ .publicProfile ])
        facebookSignInBtn.delegate = self
        facebookSignInBtn.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(facebookSignInBtn)
        view.sendSubview(toBack: facebookSignInBtn)
        facebookSignInBtn.bottomAnchor.constraint(equalTo: googleSignInBtn.topAnchor, constant: -10).isActive = true
        facebookSignInBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        facebookSignInBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        facebookSignInBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
    }
    
    func setupGoogleButton(){
        GIDSignIn.sharedInstance().clientID = "137184194492-5iokn36749o7gmlodjnv6gskddjen7p1.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        googleSignInBtn.style = GIDSignInButtonStyle.wide
    }
    
    func animateShimmeringText() {
        shimmerAppNameLabel = ShimmeringLabel(textColor: themeColor, view: view)
        appNameLabel = ShimmeringLabel(textColor: themeColor.withAlphaComponent(0.8), view: view)
        
        view.addSubview(shimmerAppNameLabel)
        view.addSubview(appNameLabel)
        
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
        animation.fromValue = -view.frame.width
        animation.toValue = view.frame.width
        gradient.add(animation, forKey: "shimmerKey")
    }
}
