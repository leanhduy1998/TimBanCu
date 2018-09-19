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
    
    private func setUpAppNameStackView() {
        appNameStackView = UIStackView()
        appNameStackView.axis = .horizontal
        appNameStackView.distribution = .fillProportionally
        appNameStackView.alignment = .center
        appNameStackView.spacing = 0
        appNameStackView.translatesAutoresizingMaskIntoConstraints = false
        
        viewcontroller.view.addSubview(appNameStackView)
        viewcontroller.view.sendSubview(toBack: appNameStackView)
        
        appNameStackView.centerXAnchor.constraint(equalTo: viewcontroller.view.centerXAnchor).isActive = true
        appNameStackView.topAnchor.constraint(equalTo: viewcontroller.view.topAnchor, constant: 120).isActive = true
        appNameStackView.widthAnchor.constraint(equalToConstant: viewcontroller.view.frame.width)
        appNameStackView.heightAnchor.constraint(equalToConstant: 100)
    }
    
    @objc private func animateAppName() {
        let appName = APP_NAME
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
        label.textColor = PRIMARY_COLOR
        label.text = text
        //charInAppNameLabel[index].font = UIFont.systemFont(ofSize: 50)
        //label.font = UIFont(name: "FS-Playlist-Caps", size: 70)
        label.font = UIFont(name: "FSNokioBold", size: 60)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = PRIMARY_COLOR
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
