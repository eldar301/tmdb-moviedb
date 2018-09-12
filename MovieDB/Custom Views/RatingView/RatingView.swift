//
//  RatingView.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 26/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

@IBDesignable class RatingView: UIViewNibInitiazlied {

    @IBInspectable var rating: CGFloat = 0 {
        didSet {
            
        }
    }

    @IBInspectable var votesCount: Int = 0 {
        didSet {
            votesLabel.text = "(\(votesCount))"
            votesLabel.sizeToFit()
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable var votesLabelSpacing: CGFloat = 0 {
        didSet {
            countLabelLeadingConstraint.constant = votesLabelSpacing
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable var votesLabelFontSize: CGFloat = 0 {
        didSet {
            votesLabel.font = UIFont(name: votesLabel.font.fontName, size: votesLabelFontSize)
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable var starSpacing: CGFloat = 0 {
        didSet {
            for constraint in starsLeadingConstraints {
                constraint.constant = starSpacing
            }
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBOutlet weak var countLabelLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet var starsLeadingConstraints: [NSLayoutConstraint]!
    
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var startFour: UIImageView!
    @IBOutlet weak var startFive: UIImageView!

    @IBOutlet weak var votesLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for (index, star) in [starOne!, starTwo!, starThree!, startFour!, startFive!].enumerated() {
            let mask = star.layer.mask!
            
            if CGFloat(index + 1) <= rating {
                mask.frame = star.bounds
            } else if CGFloat(index) ... CGFloat(index + 1) ~= rating {
                let height = star.bounds.height
                let width = height * (rating - CGFloat(index))
                mask.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
            } else {
                mask.frame = star.bounds
                mask.backgroundColor = nil
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let height = self.bounds.height
        let starWidth = height
        let width = (starWidth * 5) + (starSpacing * 4) + votesLabelSpacing + votesLabel.bounds.width
        
        return CGSize(width: width, height: height)
    }
    
    override func viewDidLoad() {
        for star in [starOne!, starTwo!, starThree!, startFour!, startFive!] {
            star.image = star.image?.withRenderingMode(.alwaysTemplate)
            star.tintColor = .red
            
            let mask = CALayer()
            mask.backgroundColor = UIColor.black.cgColor
            star.layer.mask = mask
        }
    }

}
