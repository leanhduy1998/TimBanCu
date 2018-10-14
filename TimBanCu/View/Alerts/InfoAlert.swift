//
//  NoResultAlert.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/18/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import Lottie

// should not subclass uialertcontroller because of https://developer.apple.com/documentation/uikit/uialertcontroller#//apple_ref/doc/uid/TP40014538-CH1-SW2
class InfoAlert{
    
    var alert: UIAlertController!
    var showAlertCompleteHandler: (()->Void)?
    
    private var animation:LOTAnimationView!
    private var animationName: String!
    private var animationHeight: CGFloat!
    private var alertType: AlertType!

    init(title:String,message:String, alertType: AlertType){
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true, completion: nil)
            if(self.showAlertCompleteHandler != nil){
                self.showAlertCompleteHandler!()
            }
        }))
        self.alertType = alertType
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300)
        alert.view.addConstraint(height)
        
        setUpAnimationName()
        setUpAnimation()
        setupAnimationConstraints()
    }
    
    private func setUpAnimationName(){
        switch(alertType!){
        case .Success:
            animationName = "success"
            animationHeight = 100
            break
        case .Error:
            animationName = "bikingishard"
            animationHeight = 120
            break
        case .AlreadyExist:
            animationName = "yearError"
            animationHeight = 150
            break
        case .Info:
            animationName = "info"
            animationHeight = 150
            break
        case .YearIsInTheFuture:
            animationName = "yearError"
            animationHeight = 150
            break
        case .YearOutOfLowerBound:
            animationName = "yearError"
            animationHeight = 150
            break
        case .MissingImage:
            animationName = "postcard"
            animationHeight = 250
            break
        }
    }
    
    private func setUpAnimation() {
        animation = LOTAnimationView(name: animationName)
        animation.contentMode = .scaleAspectFit
        animation.loopAnimation = true
        animation.play()
        animation.translatesAutoresizingMaskIntoConstraints = false
        alert.view.addSubview(animation)
    }
    
    private func setupAnimationConstraints(){
        animation.heightAnchor.constraint(equalToConstant: animationHeight).isActive = true
        animation.widthAnchor.constraint(equalToConstant: 250).isActive = true
        animation.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        animation.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor).isActive = true
    }
    
    func changeMessage(message:String){
        alert.message = message
    }
    
    func show(viewcontroller:UIViewController){
        viewcontroller.present(alert, animated: true, completion: nil)
    }
    func show(viewcontroller:UIViewController,showAlertCompleteHandler: (()->Void)?){
        self.showAlertCompleteHandler = showAlertCompleteHandler
        viewcontroller.present(alert, animated: true, completion: nil)
    }
    
}
