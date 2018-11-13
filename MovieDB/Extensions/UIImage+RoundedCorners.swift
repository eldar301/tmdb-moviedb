//
//  UIImage+RoundedCorners.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 13/11/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

extension UIImage {
    
    func rounded(forSize size: CGSize, withCornerRadius cornerRadius: CGFloat, backgroundColor: CGColor) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor)
        context?.fill(rect)
        
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        
        self.draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
