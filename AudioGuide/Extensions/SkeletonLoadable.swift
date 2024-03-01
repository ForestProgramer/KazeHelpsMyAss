//
//  SkeletonLoadable.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 12.01.2024.
//

//import Foundation
//import QuartzCore
//import UIKit
//
//
//protocol SkeletonLoadable{}
//
//extension SkeletonLoadable{
//    func makeAnimation(with view : UIView, previousGroup : CAAnimationGroup? = nil)-> CAAnimationGroup{
//        let animationDuration: CFTimeInterval = 0.8
//        let animation = CABasicAnimation(keyPath: "transform.translation.x")
//        animation.fromValue = -view.bounds.width
//        animation.toValue = view.frame.width / 2
//        animation.repeatCount = Float.infinity
//        animation.duration = animationDuration
//        animation.beginTime = 0.0
//        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
//        opacityAnimation.fromValue = 1
//        opacityAnimation.toValue = 0
//        opacityAnimation.repeatCount = .infinity
//        opacityAnimation.autoreverses = true
//        opacityAnimation.duration = animationDuration / 3
//        opacityAnimation.beginTime = 0.0
//        
//        // Grouping both animations
//        let group = CAAnimationGroup()
//        group.animations = [animation, opacityAnimation]
//        group.duration = animationDuration
//        group.repeatCount = .infinity
//        
//        if let previousGroup = previousGroup{
//            animation.beginTime = previousGroup.beginTime + 0.3
//        }
//        return group
//    }
//}
