//
//  PopularCell.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 22/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class FullsizeMovieCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5.0
        
        self.backgroundColor = .clear
        
        posterImageView.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.sd_cancelCurrentImageLoad()
        posterImageView.image = nil
        
        titleLabel.text = nil
    }
    
    func configure(withMovie movie: Movie) {
        titleLabel.text = movie.title
        posterImageView.sd_setImage(with: movie.posterURL ?? movie.backdropURL, placeholderImage: nil, options: []) { image, error, cacheType, imageURL in
            self.titleLabel.text = nil
        }

    }

}
