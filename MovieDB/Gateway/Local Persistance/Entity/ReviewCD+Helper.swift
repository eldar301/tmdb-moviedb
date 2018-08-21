//
//  ReviewCD+Helper.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 21/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

extension ReviewCD {
    
    @nonobjc var review: Review {
        var review = Review(id: self.id!)
        
        review.author = self.author
        review.content = self.content
        
        return review
    }
    
}
