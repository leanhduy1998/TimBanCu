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
    
    
    var noResultLabel:NoResultLabel!
    var noResultAddNewSchoolBtn:NoResultButton!
    private var animatedEmoticon:LOTAnimationView!
    private let emojiName = "empty_list"
    
    var addBtnHandler: ()->()
    
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
    
    init(type:NoResultType,addBtnHandler: @escaping ()->()){
        
        self.addBtnHandler = addBtnHandler
        super.init(frame: CGRect.zero)
        
        noResultLabel = NoResultLabel(type: type)
        noResultAddNewSchoolBtn = NoResultButton(type: type)
        
        self.addSubview(noResultLabel)
        self.addSubview(noResultAddNewSchoolBtn)
        
        
        
        animatedEmoticon = LOTAnimationView(name: "empty_list")
        animatedEmoticon.contentMode = .scaleAspectFill
        animatedEmoticon.loopAnimation = true
        animatedEmoticon.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(animatedEmoticon)
        
        animatedEmoticon.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        animatedEmoticon.heightAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.widthAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        noResultLabel.translatesAutoresizingMaskIntoConstraints = false
        noResultLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        noResultLabel.topAnchor.constraint(equalTo: animatedEmoticon.bottomAnchor, constant: 20).isActive = true
        noResultLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        noResultLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        

        noResultAddNewSchoolBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        noResultAddNewSchoolBtn.topAnchor.constraint(equalTo: noResultLabel.bottomAnchor, constant: 20).isActive = true
        noResultAddNewSchoolBtn.widthAnchor.constraint(equalToConstant: 300).isActive = true
        noResultAddNewSchoolBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true

        
        noResultAddNewSchoolBtn.addTarget(self, action: #selector(self.addNewSchoolBtnPressed(_:)), for: .touchUpInside)
    }
    
    @objc func addNewSchoolBtnPressed(_ sender: UIButton?) {
        addBtnHandler()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
