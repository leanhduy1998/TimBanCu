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
    func setupNoResultLabelAndButton(){
        view.addSubview(noResultLabel)
        view.addSubview(noResultAddNewMajorBtn)
        
        view.bringSubview(toFront: noResultLabel)
        view.bringSubview(toFront: noResultAddNewMajorBtn)
        
        noResultLabel.textColor = UIColor.darkGray
        noResultLabel.textAlignment = .center
        noResultLabel.numberOfLines = 0
        noResultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        noResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        noResultLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        //noResultLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        noResultAddNewMajorBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultAddNewMajorBtn.topAnchor.constraint(equalTo: noResultLabel.bottomAnchor, constant: 20).isActive = true
        noResultAddNewMajorBtn.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        noResultAddNewMajorBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        noResultAddNewMajorBtn.addTarget(self, action: #selector(self.addNewMajorBtnPressed(_:)), for: .touchUpInside)
    }
}
