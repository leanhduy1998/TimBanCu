//
//  AnimateAppName.swift
//  TimBanCu
//
//  Created by Vy Le on 9/21/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class AnimateAppNameView {
    
    private var shimmerAppNameLabel: ShimmeringLabel! = nil
    private var appNameLabel:ShimmeringLabel! = nil
    
    private var appNameStackView: UIStackView!
    private weak var viewcontroller: UIViewController!
    
    init(viewController: UIViewController) {
        self.viewcontroller = viewController
        setUpAppNameStackView()
    }
    
    //set-ups
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
        appNameStackView.topAnchor.constraint(equalTo: viewcontroller.view.topAnchor, constant: (viewcontroller.view.frame.height / 6) + 10).isActive = true
        appNameStackView.widthAnchor.constraint(equalToConstant: viewcontroller.view.frame.width)
        appNameStackView.heightAnchor.constraint(equalToConstant: 100)
    }
    
    private func setUpShimmeringAppName() {
        appNameLabel = ShimmeringLabel(textColor: Constants.AppColor.primaryColor,view:viewcontroller.view)
        shimmerAppNameLabel = ShimmeringLabel(textColor: Constants.AppColor.darkPrimaryColor, view: viewcontroller.view)
        
        viewcontroller.view.addSubview(shimmerAppNameLabel)
        viewcontroller.view.addSubview(appNameLabel)
        viewcontroller.view.sendSubview(toBack: shimmerAppNameLabel)
        viewcontroller.view.sendSubview(toBack: appNameLabel)
    }
    
    func resetView(){
        DispatchQueue.main.async {
            for view in self.appNameStackView.arrangedSubviews{
                view.removeFromSuperview()
            }
            
            self.viewcontroller.viewDidLayoutSubviews()
        }
        
    }
    
    //chain animation
    func animate() {
        DispatchQueue.main.async {
            Timer.scheduledTimer(timeInterval: TimeInterval(2.0), target: self, selector: #selector(self.animateLettersSlideIn), userInfo: nil, repeats: false)
            
            Timer.scheduledTimer(timeInterval: TimeInterval(3.0), target: self, selector: #selector(self.animateShimmeringText), userInfo: nil, repeats: false)
        }
    }
    
    //MARK: First Animation
    @objc private func animateLettersSlideIn() {
        
        let appName = Constants.App.name
        var charInAppName = [String]()
        var charInAppNameLabel = [UILabel]()
        
        for character in appName {
            charInAppName.append(String(character))
        }
        
        for i in 0..<charInAppName.count {
            charInAppNameLabel.append(UILabel())
            
            setUpAppNameLabel(label: charInAppNameLabel[i], text: charInAppName[i])
            appNameStackView.addArrangedSubview(charInAppNameLabel[i])
            
            animateEachLetterOfAppName(letter: charInAppNameLabel[i], index: i)
        }
        
        
    }
    
    private func setUpAppNameLabel(label: UILabel, text: String) {
        label.text = text
        label.font = UIFont(name: Constants.App.font, size: 60)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.AppColor.primaryColor
        label.textAlignment = .center
    }
    
    private func animateEachLetterOfAppName(letter: UILabel, index: Int) {
        letter.transform = CGAffineTransform(translationX: 0, y: 10)
        letter.alpha = 0
        
        UIView.animate(withDuration: 0.6, delay: 0.05 * Double(index), options: [.curveEaseInOut], animations: {
            letter.transform = CGAffineTransform(translationX: 0, y: 0)
            letter.alpha = 1
        }, completion: nil)
    }
    
    //MARK: Second Animation
    @objc private func animateShimmeringText() {
        setUpShimmeringAppName()
        
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
        
        for view in appNameStackView.arrangedSubviews{
            view.removeFromSuperview()
        }
        
    }
    
}
