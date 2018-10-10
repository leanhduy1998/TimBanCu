//
//  LoadingAnimation.swift
//  TimBanCu
//
//  Created by Vy Le on 10/6/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import Lottie

class LoadingAnimation: UIView {
    
    private weak var viewcontroller: UIViewController!
    
    private var animation: LOTAnimationView!
    private let animationName = "biking_is_cool"
    
    private var loadingLabel: UILabel!
    private var blackFilter: BlackFilterBackground!
    
    init(viewcontroller: UIViewController) {
        super.init(frame: CGRect.zero)
        
        self.viewcontroller = viewcontroller
        viewcontroller.view.addSubview(self)
        viewcontroller.view.bringSubview(toFront: self)
        
        setUpSelf()
        setSelfConstraints()
        
        setupAnimation()
        setupAnimationnConstraints()
        
        setUpLoadingLabel()
        setUpLoadingLabelConstraints()
    }
    
    private func setUpLoadingLabel() {
        loadingLabel = UILabel()
        loadingLabel.text = "Loading..."
        loadingLabel.textAlignment = .center
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loadingLabel)
        
    }
    
    private func setUpLoadingLabelConstraints() {
        loadingLabel.bottomAnchor.constraint(equalTo: animation.topAnchor, constant: 15).isActive = true
        loadingLabel.leftAnchor.constraint(equalTo: viewcontroller.view.leftAnchor, constant: 20).isActive = true
        loadingLabel.rightAnchor.constraint(equalTo: viewcontroller.view.rightAnchor, constant: -20).isActive = true
        loadingLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    private func setupAnimation(){
        animation = LOTAnimationView(name: animationName)
        animation.contentMode = .scaleAspectFill
        animation.loopAnimation = true
        animation.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(animation)
    }
    
    func playAnimation(){
        self.blackFilter = BlackFilterBackground(viewcontroller: self.viewcontroller)
        animation.play()
    }
    
    func stopAnimation() {
        blackFilter.removeFromSuperview()
        animation.stop()
    }
    
    private func setupAnimationnConstraints(){
        animation.heightAnchor.constraint(equalToConstant: 150).isActive = true
        animation.widthAnchor.constraint(equalToConstant: 150).isActive = true
        animation.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        animation.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 15).isActive = true
    }
    
    private func setSelfConstraints(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerYAnchor.constraint(equalTo: viewcontroller.view.centerYAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: viewcontroller.view.centerXAnchor).isActive = true
        self.widthAnchor.constraint(equalToConstant: viewcontroller.view.frame.width / 2).isActive = true
        self.heightAnchor.constraint(equalToConstant: viewcontroller.view.frame.width / 2).isActive = true
    }
    
    private func setUpSelf() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 30
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        self.layer.shadowColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 0.5).cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
