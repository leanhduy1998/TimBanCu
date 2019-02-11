//
//  NoResultVCFactory.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class NoResultVCFactory{
    static func getNoResultViewControllerForSchoolViewController(handleAction:@escaping ()->Void)->NoResultViewController{
        let controller = NoResultViewController()
        controller.inject(titleStr: "Không có kết quả. Bạn vui lòng điền có dấu.\n Bạn có muốn thêm trường mới?", textfieldPlaceholder: "Tên Trường", actionStr: "Thêm Trường Mới", handleAction: handleAction)
        return controller
    }
}
