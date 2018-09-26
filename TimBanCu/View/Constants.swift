//
//  Colors.swift
//  TimBanCu
//
//  Created by Vy Le on 8/6/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

struct Constants {
    struct App {
        static let name = "Tìm Bạn Cũ"
        static let font = "FSNokioBold"
        static let fontSize: CGFloat = 60.0
    }
    
    struct AppColor {
        static let primaryColor = UIColor(red: 1, green: 158/255, blue: 0, alpha: 1.0)
        static let darkPrimaryColor = UIColor(red: 255/255, green: 117/255, blue: 0, alpha: 1.0)
    }
    
    struct UnderlineColor {
        static let showUnderline = AppColor.primaryColor
        static let hideUnderline = AppColor.primaryColor.withAlphaComponent(0.6)
    }
    
}
