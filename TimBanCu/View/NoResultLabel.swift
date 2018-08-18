//
//  NoResultLabel.swift
//  TimBanCu
//
//  Created by Vy Le on 7/17/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

enum Type:String {
    case School
    case University
    case Class
    case Student
}

class NoResultLabel: UILabel {
    

    //"Không có kết quả. Bạn vui lòng điền có dấu. Bạn có muốn thêm tên trường?"
    
    
    
    init(type:Type) {
        super.init(frame: .zero)
        
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
        default:
            break
        }

        
        self.textColor = UIColor.darkGray
        self.textAlignment = .center
        self.numberOfLines = 3
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setConstraints(view:UIView,animatedEmoticon:UIView){
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.topAnchor.constraint(equalTo: animatedEmoticon.bottomAnchor, constant: 20).isActive = true
        self.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
