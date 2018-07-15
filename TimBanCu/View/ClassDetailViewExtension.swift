//
//  ClassDetailViewExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/15/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension ClassDetailViewController{
    func setupNoResultLabelAndButton(topViewY:CGFloat, topViewHeight:CGFloat){
        
        let y = topViewY + topViewHeight + 40
        
        noResultLabel.frame = CGRect(x: 0, y: y, width: view.frame.width, height: 80)
        noResultLabel.text = "Chưa có lớp. Bạn có muốn thêm lớp? Ví dụ: 10A11"
        noResultLabel.numberOfLines = 2
        
        noResultAddNewClassBtn.frame = CGRect(x: 0, y: y + 80, width: view.frame.width, height: 40)
        noResultAddNewClassBtn.setTitle("Thêm Lớp Mới", for: .normal)
        noResultAddNewClassBtn.setTitleColor(UIColor.blue, for: .normal)
        
        noResultAddNewClassBtn.addTarget(self, action: #selector(self.addNewSchoolBtnPressed(_:)), for: .touchUpInside)
        
        view.addSubview(noResultLabel)
        view.addSubview(noResultAddNewClassBtn)
        
        view.bringSubview(toFront: noResultLabel)
        view.bringSubview(toFront: noResultAddNewClassBtn)
        
        view.layoutIfNeeded()
    }
}
