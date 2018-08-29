//
//  CustomizeTabBarController.swift
//  TimBanCu
//
//  Created by Vy Le on 8/19/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit

class CustomizeTabBarController: UITabBarController {
    
    var secondItemImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let secondItemView = self.tabBar.subviews[1]
        self.secondItemImageView = secondItemView.subviews.first as! UIImageView
        self.secondItemImageView.contentMode = .center
        
        setupCircleLayers(item: secondItemView)
    }
    
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.fillColor = fillColor.cgColor
        layer.lineCap = kCALineCapRound
        layer.position = view.center
        return layer
    }
    
    private func setupCircleLayers(item: UITabBarItem) {
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor.orange)
        tabBarItemCircleView.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
        
        shapeLayer = createCircleShapeLayer(strokeColor: UIColor.orange, fillColor: .clear)

        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.5
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            //do our animations
            animatePulsatingLayer()
        }
    }

    
}
