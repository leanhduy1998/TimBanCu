//
//  MajorExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/5/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension MajorViewController{
    
    func setUpAnimatedEmoticon() {
        view.addSubview(animatedEmoticon)
        animatedEmoticon.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        animatedEmoticon.heightAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.widthAnchor.constraint(equalToConstant: 150).isActive = true
        animatedEmoticon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupNoResultLabelAndButton(){
        view.addSubview(noResultLabel)
        view.addSubview(noResultAddNewMajorBtn)
        
        noResultLabel.setConstraints(view: view, constraintTo: animatedEmoticon)
        
        noResultAddNewMajorBtn.setContraints(view: view, contraintTo: noResultLabel)
        noResultAddNewMajorBtn.addTarget(self, action: #selector(self.addNewMajorBtnPressed(_:)), for: .touchUpInside)
    }
}
