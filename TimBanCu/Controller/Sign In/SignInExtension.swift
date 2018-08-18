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

extension SignInViewController{
    func setupFacebookBtn(){
        let facebookSignInBtn = LoginButton(readPermissions: [ .publicProfile ])
        facebookSignInBtn.delegate = self
        facebookSignInBtn.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(facebookSignInBtn)
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
    
    func setupShimmeringText() {
        shimmerAppNameLabel.text = "Tìm bạn cũ"
        shimmerAppNameLabel.font = UIFont(name: "FS-Playlist-Caps", size: 70)
        shimmerAppNameLabel.textColor = themeColor
        shimmerAppNameLabel.textAlignment = .center
        
        appNameLabel.text = "Tìm bạn cũ"
        appNameLabel.font = UIFont(name: "FS-Playlist-Caps", size: 70)
        appNameLabel.textColor = themeColor.withAlphaComponent(0.85)
        appNameLabel.textAlignment = .center
        
        view.addSubview(appNameLabel)
        view.addSubview(shimmerAppNameLabel)
        
        appNameLabel.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 100)
        shimmerAppNameLabel.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 100)
        
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
