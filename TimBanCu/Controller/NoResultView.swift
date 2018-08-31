//
//  NoResultView.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/30/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class NoResultView:UIView{
    
    
    var noResultLabel:NoResultLabel!
    var noResultAddNewSchoolBtn:NoResultButton!
    private var animatedEmoticon:AnimatedEmoticon!
    private let emojiName = "empty_list"
    
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
                animatedEmoticon.play()
            }
        }
    }
    
    init(type:NoResultType){
        super.init(frame: CGRect.zero)
        noResultLabel = NoResultLabel(type: NoResultType.School)
        noResultAddNewSchoolBtn = NoResultButton(type: NoResultType.School)
        
        self.addSubview(noResultLabel)
        self.addSubview(noResultAddNewSchoolBtn)
        
        animatedEmoticon = AnimatedEmoticon(view: self)
        noResultLabel.setConstraints(view: self, constraintTo: animatedEmoticon)
        noResultAddNewSchoolBtn.setContraints(view: self, contraintTo: noResultLabel)
        
     //   noResultAddNewSchoolBtn.addTarget(self, action: #selector(self.addNewSchoolBtnPressed(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
