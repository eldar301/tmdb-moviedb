//
//  GradientView.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 07/11/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class GradientView: UIView {

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }

}
