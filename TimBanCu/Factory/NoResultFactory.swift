//
//  NoResultFactory.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class NoResultFactory{
    static func build(viewcontroller:UIViewController)->NoResultViewController{
        
        let noResultVC = NoResultViewController.initFromNib()
        
        switch(viewcontroller){
        case is SchoolViewController:
            noResultVC.inject(titleStr: "Không có kết quả. Bạn có muốn thêm trường mới?\nBạn vui lòng điền có dấu", textfieldPlaceholder: "Tên Trường", actionStr: "Thêm Trường Mới")
            break
            
        case is MajorViewController:
            noResultVC.inject(titleStr: "Không có kết quả. Bạn có muốn thêm tên khoa mới? Ví Dụ: Khoa Kinh Tế\nBạn vui lòng điền có dấu", textfieldPlaceholder: "Tên Khoa", actionStr: "Thêm Khoa Mới")
            break
            
        default:
            noResultVC.inject(titleStr: "Không có kết quả", textfieldPlaceholder: "Tên", actionStr: "Thêm")
            break
        }
        
        return noResultVC
    }
}
