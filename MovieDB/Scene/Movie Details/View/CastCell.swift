//
//  CastCell.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 24/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class CastCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.sd_cancelCurrentImageLoad()
        profileImageView.image = nil
    }
    
    func configure(cast: Person) {
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.text = cast.name
        
        profileImageView.sd_setImage(with: cast.profileImageURL)
    }

}
