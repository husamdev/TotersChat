//
//  UIColor+Extensions.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/11/20.
//

import Foundation
import UIKit

extension UIView {
    
    func applyMyGreenGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = UIScreen.main.bounds
        let myDrakGreen = UIColor(red: 43/255, green: 146/255, blue: 160/255, alpha: 1)
        let myLightGreen = UIColor(red: 112/255, green: 207/255, blue: 188/255, alpha: 1)
        gradientLayer.colors = [myDrakGreen.cgColor, myLightGreen.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
