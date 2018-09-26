//
//  NoResultLabel.swift
//  TimBanCu
//
//  Created by Vy Le on 7/17/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class NoResultLabel: UILabel {

    init(type:NoResultType) {
        super.init(frame: .zero)
        setUpText(type: type)
        self.textColor = UIColor.darkGray
        self.textAlignment = .center
        self.numberOfLines = 3
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setUpText(type: NoResultType) {
        switch(type){
        case .School:
            self.text = "Không có kết quả. Bạn vui lòng điền có dấu.\n Bạn có muốn thêm tên trường?"
            break
        case .University:
            self.text = "Không có kết quả. Bạn vui lòng điền có dấu. Bạn có muốn thêm tên khoa mới? Ví Dụ: Khoa Kinh Tế"
            break
        case .Class:
            self.text = "Chưa có lớp. Bạn có muốn thêm lớp?\n Ví dụ: 10A11"
            break
        case .Student:
            self.text = "Chưa có học sinh nào.\n Bạn có muốn thông tin của mình?"
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
