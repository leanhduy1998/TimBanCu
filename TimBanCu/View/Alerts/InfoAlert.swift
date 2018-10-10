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
    private var successAnimation: Bool!

    init(title:String,message:String,successAnimation: Bool){
        self.successAnimation = successAnimation
        
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true, completion: nil)
            if(self.showAlertCompleteHandler != nil){
                self.showAlertCompleteHandler!()
            }
        }))
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300)
        alert.view.addConstraint(height)
        
        setUpAnimation()
        setupAnimationnConstraints()
    }
    
    private func setUpAnimationName() {
        if successAnimation {
            animationName = "success"
        } else {
            animationName = "bikingishard"
        }
        
    }
    
    private func setUpAnimation() {
        animation = LOTAnimationView(name: animationName)
        animation.contentMode = .scaleAspectFill
        animation.loopAnimation = true
        animation.play()
        animation.translatesAutoresizingMaskIntoConstraints = false
        alert.view.addSubview(animation)
    }
    
    private func setupAnimationnConstraints(){
        animation.heightAnchor.constraint(equalToConstant: 150).isActive = true
        animation.widthAnchor.constraint(equalToConstant: 200).isActive = true
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
