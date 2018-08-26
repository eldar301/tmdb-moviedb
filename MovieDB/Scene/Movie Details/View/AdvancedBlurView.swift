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
    
    fileprivate weak var subLayer: CALayer!
    
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
        subLayer.frame = self.bounds
        CATransaction.commit()
    }

    func addLayer(layer: CALayer) {
        self.layer.addSublayer(layer)
        
        subLayer = layer
    }
    
}
