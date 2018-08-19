//
//  NoResultButton.swift
//  TimBanCu
//
//  Created by Vy Le on 7/17/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class NoResultButton: UIButton {
    
    init(type: Type) {
        super.init(frame: .zero)
        let title = setUpText(type: type)
        self.setAttributedTitle(NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold), NSAttributedStringKey.foregroundColor: themeColor]), for: .normal)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setContraints(view: UIView, contraintTo label: UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        self.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        self.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setUpText(type: Type) -> String {
        var title: String
        switch(type){
        case .School:
            title = "Thêm Trường Mới"
            break
        case .University:
            title = "Thêm Khoa Mới"
            break
        case .Class:
            title = "Thêm Lớp Mới"
            break
        case .Student:
            title = "Thêm Thông Tin Của Mình"
            break
        default:
            break
        }
        return title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
