//
//  SchoolExtensionAnimation.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 2/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

extension SchoolViewController{
    func setupLoadingAnimation(){
        loadingAnimation = LoadingAnimation(viewcontroller: self)
        loadingAnimation.isHidden = true
    }
    
    func stopLoadingAnimation() {
        loadingAnimation.isHidden = true
        loadingAnimation.stopAnimation()
    }
    
    func showLoading(){
        noResultVC.view.isHidden = true
        tableview.isHidden = true
        playLoadingAnimation()
    }
    
    private func playLoadingAnimation(){
        loadingAnimation.isHidden = false
        loadingAnimation.playAnimation()
    }
}
