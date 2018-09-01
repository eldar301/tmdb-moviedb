//
//  UIViewNibInitiazlied.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 31/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class UIViewNibInitiazlied: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func viewDidLoad() { }
    
    func setup() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        let view = nib.instantiate(withOwner: self).first as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
        viewDidLoad()
    }
    
}
