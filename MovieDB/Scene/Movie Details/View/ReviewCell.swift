//
//  ReviewCell.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 23/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class ReviewCell: UICollectionViewCell {

    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var content: UILabel!

    func configure(review: Review) {
        author.text = review.author
        content.text = review.content
    }

}
