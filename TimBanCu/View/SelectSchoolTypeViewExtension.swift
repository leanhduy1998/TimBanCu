//
//  SelectSchoolToScanViewExtension.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/14/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension SelectSchoolTypeViewController{
    func addNavigationBarShadow() {
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationController?.navigationBar.layer.shadowColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 0.5).cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.shadowRadius = 10.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.addBorder(side: .Bottom, color: UIColor(red: 255/255, green: 179/255, blue: 0/255, alpha: 1.0), thickness: 1.5)
    }
}

extension UIView {
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(side: ViewSide, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        layer.addSublayer(border)
    }
}
