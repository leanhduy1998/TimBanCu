//
//  NoResultView.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/30/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class NoResultView:UIView{
    
    private var noResultLabel:NoResultLabel!
    private var noResultAddNewSchoolBtn:NoResultButton!
    private var animatedEmoticon:LOTAnimationView!
    private let emojiName = "empty_list"
    private var searchTF:UITextField!
    private weak var viewcontroller:UIViewController!
    
    var addBtnPressedClosure: ()->()
    
    override var isHidden: Bool {
        get{
            return super.isHidden
        }
        set(newVal){
            super.isHidden = newVal
            
            if(super.isHidden){
                animatedEmoticon.stop()
            }
            else{
                if(!animatedEmoticon.isAnimationPlaying){
                    animatedEmoticon.play()
                }
            }
        }
    }
    
    init(viewcontroller:UIViewController,searchTF:UITextField,type:NoResultType,addBtnPressedClosure: @escaping ()->()){
        
        
        self.addBtnPressedClosure = addBtnPressedClosure
        super.init(frame: CGRect.zero)
        self.searchTF = searchTF
        self.viewcontroller = viewcontroller
        
        noResultLabel = NoResultLabel(type: type)
        noResultAddNewSchoolBtn = NoResultButton(type: type)
        
        self.addSubview(noResultLabel)
        self.addSubview(noResultAddNewSchoolBtn)
        
        
        
        setupAnimatedEmoticon()
        setAnimatedEmoticonConstraints()
        setNoResultLabelConstraints()
        setNoResultBtnConStraints()
        
        noResultAddNewSchoolBtn.addTarget(self, action: #selector(self.addNewSchoolBtnPressed(_:)), for: .touchUpInside)
        
        
        viewcontroller.view.addSubview(self)
        
        setSelfConstraints()
    }
    
    private func setupAnimatedEmoticon(){
        animatedEmoticon = LOTAnimationView(name: "empty_list")
        animatedEmoticon.contentMode = .scaleAspectFill
        animatedEmoticon.loopAnimation = true
        animatedEmoticon.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(animatedEmoticon)
    }
    
    private func setAnimatedEmoticonConstraints(){
        animatedEmoticon.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        animatedEmoticon.heightAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.widthAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func setNoResultLabelConstraints(){
        noResultLabel.translatesAutoresizingMaskIntoConstraints = false
        noResultLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        noResultLabel.topAnchor.constraint(equalTo: animatedEmoticon.bottomAnchor, constant: 20).isActive = true
        noResultLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        noResultLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setNoResultBtnConStraints(){
        noResultAddNewSchoolBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        noResultAddNewSchoolBtn.topAnchor.constraint(equalTo: noResultLabel.bottomAnchor).isActive = true
        noResultAddNewSchoolBtn.widthAnchor.constraint(equalToConstant: 300).isActive = true
        noResultAddNewSchoolBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setSelfConstraints(){
        self.topAnchor.constraint(equalTo: searchTF.topAnchor, constant: 20).isActive = true
        self.leftAnchor.constraint(equalTo: viewcontroller.view.leftAnchor, constant: 20).isActive = true
        self.rightAnchor.constraint(equalTo: viewcontroller.view.rightAnchor, constant: 20).isActive = true
        self.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.widthAnchor.constraint(equalToConstant: viewcontroller.view.frame.width).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func addNewSchoolBtnPressed(_ sender: UIButton?) {
        addBtnPressedClosure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
