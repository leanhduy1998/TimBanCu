//
//  NoResultButton.swift
//  TimBanCu
//
//  Created by Vy Le on 7/17/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class NoResultButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setAttributedTitle(NSAttributedString(string: currentTitle ?? "", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold), NSAttributedStringKey.foregroundColor: Constants.AppColor.primaryColor]), for: .normal)
    }
    
    
    
    /*private func setUpText(type: NoResultType) -> String {
        var title: String
        switch(type){
        case .Institution:
            title = "Thêm Trường Mới"
            break
        case .Major:
            title = "Thêm Khoa Mới"
            break
        case .Class:
            title = "Thêm Lớp Mới"
            break
        case .Student:
            title = "Thêm Thông Tin Của Mình"
            break
        }
        return title
    }*/
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
