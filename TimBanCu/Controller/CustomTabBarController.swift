//
//  CustomTabBarController.swift
//  TimBanCu
//
//  Created by Vy Le on 8/20/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    var firstItemImageView: UIImageView!
    var secondItemImageView: UIImageView!
    var thirdItemImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            scaleAnimation(imageView: firstItemImageView)
        } else if item.tag == 1 {
            scaleAnimation(imageView: secondItemImageView)
        } else if item.tag == 2 {
            scaleAnimation(imageView: thirdItemImageView)
        }
    }
    
    func setUp() {
        let firstItemView = self.tabBar.subviews[0]
        self.firstItemImageView = firstItemView.subviews.first as! UIImageView
        self.firstItemImageView.contentMode = .center
        
        let secondItemView = self.tabBar.subviews[1]
        self.secondItemImageView = secondItemView.subviews.first as! UIImageView
        self.secondItemImageView.contentMode = .center
        
        let thirdItemView = self.tabBar.subviews[2]
        self.thirdItemImageView = thirdItemView.subviews.first as! UIImageView
        self.thirdItemImageView.contentMode = .center
    }

    func scaleAnimation(imageView: UIImageView) {
        imageView.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: {
            imageView.transform = .identity
        }, completion: nil)
    }
    
}
