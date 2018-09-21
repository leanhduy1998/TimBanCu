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
    private var shimmerAppNameLabel: ShimmeringLabel! = nil
    private var appNameLabel:ShimmeringLabel! = nil
    private var appNameStackView: UIStackView!
    
    private var facebookBtn:LoginButton!
    private var googleBtn:GIDSignInButton!
    
    private var errorAlert:InfoAlert!
    
    init(viewController: SignInViewController, facebookBtn:LoginButton, googleBtn:GIDSignInButton) {
        self.viewcontroller = viewController
        self.facebookBtn = facebookBtn
        self.googleBtn = googleBtn
        
        setUpSplashView()
        setUpAppNameStackView()
        setupFacebookBtn()
        setupGoogleButton()

        Timer.scheduledTimer(timeInterval: TimeInterval(2.0), target: self, selector: #selector(animateAppName), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: TimeInterval(3.0), target: self, selector: #selector(animateShimmeringText), userInfo: nil, repeats: false)
        
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
    
    @objc private func animateShimmeringText() {
        appNameLabel = ShimmeringLabel(textColor: Constants.AppColor.primaryColor,view:viewcontroller.view)
        shimmerAppNameLabel = ShimmeringLabel(textColor: Constants.AppColor.darkPrimaryColor, view: viewcontroller.view)
        
        viewcontroller.view.addSubview(shimmerAppNameLabel)
        viewcontroller.view.addSubview(appNameLabel)
        viewcontroller.view.sendSubview(toBack: shimmerAppNameLabel)
        viewcontroller.view.sendSubview(toBack: appNameLabel)
        
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
        animation.fromValue = -viewcontroller.view.frame.width
        animation.toValue = viewcontroller.view.frame.width
        gradient.add(animation, forKey: "shimmerKey")
        
        appNameStackView.removeFromSuperview()
    }
    
    private func setUpAppNameStackView() {
        appNameStackView = UIStackView()
        appNameStackView.axis = .horizontal
        appNameStackView.distribution = .fillProportionally
        appNameStackView.alignment = .center
        appNameStackView.spacing = 0
        
        viewcontroller.view.addSubview(appNameStackView)
        viewcontroller.view.sendSubview(toBack: appNameStackView)
        
        appNameStackView.translatesAutoresizingMaskIntoConstraints = false
        appNameStackView.centerXAnchor.constraint(equalTo: viewcontroller.view.centerXAnchor).isActive = true
        appNameStackView.topAnchor.constraint(equalTo: viewcontroller.view.topAnchor, constant: 110).isActive = true
        appNameStackView.widthAnchor.constraint(equalToConstant: viewcontroller.view.frame.width)
        appNameStackView.heightAnchor.constraint(equalToConstant: 100)
    }
    
    @objc private func animateAppName() {
        let appName = Constants.App.name
        var charInAppName = [String]()
        var charInAppNameLabel = [UILabel]()
        
        for character in appName {
            charInAppName.append(String(character))
        }
        
        for i in 0..<charInAppName.count {
            charInAppNameLabel.append(UILabel())
            appNameStackView.addArrangedSubview(charInAppNameLabel[i])
            
            setUpAppNameLabel(label: charInAppNameLabel[i], text: charInAppName[i])
            animateSingleCharOfAppName(singleCharLabel: charInAppNameLabel[i], index: i)
        }
    }
    
    private func setUpAppNameLabel(label: UILabel, text: String) {
        label.text = text
        label.font = UIFont(name: Constants.App.font, size: 60)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.AppColor.primaryColor
        label.textAlignment = .center
    }
    
    private func animateSingleCharOfAppName(singleCharLabel: UILabel, index: Int) {
        singleCharLabel.transform = CGAffineTransform(translationX: 0, y: 10)
        singleCharLabel.alpha = 0
        
        UIView.animate(withDuration: 0.6, delay: 0.05 * Double(index), options: [.curveEaseInOut], animations: {
            singleCharLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            singleCharLabel.alpha = 1
        }, completion: nil)
    }
    
    private func setupFacebookBtn(){
        facebookBtn.translatesAutoresizingMaskIntoConstraints = false
        
        viewcontroller.view.addSubview(facebookBtn)
        viewcontroller.view.sendSubview(toBack: facebookBtn)
        facebookBtn.bottomAnchor.constraint(equalTo: googleBtn.topAnchor, constant: -10).isActive = true
        facebookBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        facebookBtn.leftAnchor.constraint(equalTo: viewcontroller.view.leftAnchor, constant: 40).isActive = true
        facebookBtn.rightAnchor.constraint(equalTo: viewcontroller.view.rightAnchor, constant: -40).isActive = true
    }
    
    private func setupGoogleButton(){
        googleBtn.style = GIDSignInButtonStyle.wide
    }
    
}
