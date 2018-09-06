//
//  MovieCell.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 05/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {
    
    fileprivate weak var titleLabel: UILabel!
    fileprivate weak var posterImageView: UIImageView!
    fileprivate weak var ratingView: RatingView!
    fileprivate weak var overviewLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.sd_cancelCurrentImageLoad()
        posterImageView.image = nil
        
        titleLabel.text = nil
    }
    
    func configure(withMovie movie: Movie) {
        titleLabel.text = movie.title
        posterImageView.sd_setImage(with: movie.posterURL ?? movie.backdropURL, placeholderImage: nil, options: [])
        
        overviewLabel.text = movie.overview
    }
    
    fileprivate func setup() {
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        
        let titleLabel = UILabel()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let posterImageView = UIImageView()
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(posterImageView)
        self.posterImageView = posterImageView
        
        let ratingView = RatingView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(ratingView)
        
        let overviewLabel = UILabel()
        overviewLabel.lineBreakMode = .byTruncatingTail
        overviewLabel.numberOfLines = 0
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(overviewLabel)
        self.overviewLabel = overviewLabel
        
        let margins = self.layoutMarginsGuide
        
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 75.0).isActive = true
        
        posterImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        posterImageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.0).isActive = true

        ratingView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor).isActive = true
        ratingView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        ratingView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        ratingView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        overviewLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor).isActive = true
        overviewLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        overviewLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        overviewLabel.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
    }
    
}
