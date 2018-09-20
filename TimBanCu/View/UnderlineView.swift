//
//  UnderlineView.swift
//  TimBanCu
//
//  Created by Vy Le on 8/19/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class UnderlineView: UIView {
    
    var underlineState: UnderlineState!
    private var lineHeight: NSLayoutConstraint?
    private var searchTF: UITextField!
    private weak var viewcontroller: UIViewController!
    
    init(viewcontroller: UIViewController, searchTF: UITextField) {
        super.init(frame: CGRect.zero)
        viewcontroller.view.addSubview(self)
        
        self.searchTF = searchTF
        self.viewcontroller = viewcontroller
        
        self.backgroundColor = Constants.AppColor.lighterPrimaryColor 
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
    }
    
    private func setupConstraints(){
        self.topAnchor.constraint(equalTo: searchTF.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: viewcontroller.view.leftAnchor, constant: 20).isActive = true
        self.rightAnchor.constraint(equalTo: viewcontroller.view.rightAnchor, constant: -20).isActive = true
        lineHeight = self.heightAnchor.constraint(equalToConstant: 1.5)
        lineHeight?.isActive = true
    }
    
    func underline() {
        switch underlineState {
        case .showUnderline?:
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.lineHeight?.constant = 2.5
                self.backgroundColor = Constants.AppColor.primaryColor
            }, completion: nil)
            break
        case .hideUnderline?:
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.lineHeight?.constant = 1.5
                self.backgroundColor = Constants.AppColor.lighterPrimaryColor
            }, completion: nil)
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
