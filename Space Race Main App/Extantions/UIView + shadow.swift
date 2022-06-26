//
//  UIView + shadow.swift
//  Space Race Main App
//
//  Created by Shemets on 6.06.22.
//

import Foundation
import UIKit


extension UIView {
    func applyCornerRadius(radius: CGFloat){
        layer.cornerRadius = radius
    }
    
    func applyShadow (shadowOpacity: Float, shadowRadius: CGFloat, shadowOffset: CGSize, shadowColor: CGColor){
            self.layer.shadowOpacity = shadowOpacity
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowOffset = shadowOffset
            self.layer.shadowColor = shadowColor
    }
}
