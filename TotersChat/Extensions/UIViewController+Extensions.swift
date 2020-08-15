//
//  UIViewController+Extensions.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/15/20.
//

import Foundation
import UIKit
import Lottie

fileprivate var loadingView: AnimationView?

extension UIViewController {
    
    func showLoading() {
        let animation = Animation.named("loading")
        let animationView = AnimationView(animation: animation)
        animationView.frame = view.frame
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
        
        loadingView = animationView
    }
    
    func removeLoading() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}

