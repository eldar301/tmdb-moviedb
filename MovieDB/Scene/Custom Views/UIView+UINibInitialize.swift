//
//  UIView+UINibInitialize.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 31/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

extension UIView {
    
    class func loadFromNib() -> Self {
        let fileOwner = self.init()
        fileOwner.setup()
        return fileOwner
    }
    
    func setup() {
        let nib = UINib(nibName: String(describing: self), bundle: Bundle(for: type(of: self)))
        let view = nib.instantiate(withOwner: self).first as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }
    
}
