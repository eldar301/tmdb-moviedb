//
//  AdvancedBlurView.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 23/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class AdvancedBlurView: UIVisualEffectView {
    
    fileprivate var animator: UIViewPropertyAnimator!

    init(effect: UIVisualEffect?, intensity: CGFloat) {
        super.init(effect: nil)
        
        animator = UIViewPropertyAnimator(duration: 1.0, curve: .linear, animations: { [unowned self] in
            self.effect = effect
        })
        
        animator.fractionComplete = intensity
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        // FIXME: - sometimes layer's sublayers missing the order
        let gradientLayer = self.layer.sublayers!.first(where: { $0 is CAGradientLayer })!
        gradientLayer.removeFromSuperlayer()
        self.layer.addSublayer(gradientLayer)
        
        for layer in self.layer.sublayers! {
            layer.frame = self.layer.bounds
        }
        
        CATransaction.commit()
    }
    
}
