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
    
    fileprivate var constraintsAreActive = false
    
    override func updateConstraints() {
        if !constraintsAreActive {
            let margins = self.layoutMarginsGuide
            
            titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
            titleLabel.heightAnchor.constraint(equalToConstant: 55.0).isActive = true
            
            posterImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
            posterImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
            posterImageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.0).isActive = true
            
            ratingView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8.0).isActive = true
            ratingView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            //        ratingView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
            //        ratingView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
            ratingView.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
            
            overviewLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 8.0).isActive = true
            overviewLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
            overviewLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
//            overviewLabel.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
            
            constraintsAreActive = true
        }
        
        super.updateConstraints()
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
        
        self.ratingView.rating = CGFloat(movie.voteAverage ?? 0.0)
        self.ratingView.votesCount = movie.voteCount ?? 0
        
        overviewLabel.text = movie.overview
        
        self.layoutIfNeeded()
    }
    
    fileprivate func setup() {
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 23.0)
        titleLabel.textColor = .white
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
        ratingView.votesLabelFontSize = 18.0
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(ratingView)
        self.ratingView = ratingView
        
        let overviewLabel = UILabel()
        overviewLabel.font = UIFont(name: "AvenirNext-Regular", size: 15.0)
        overviewLabel.textColor = .white
        overviewLabel.textAlignment = .justified
        overviewLabel.lineBreakMode = .byTruncatingTail
        overviewLabel.numberOfLines = 0
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(overviewLabel)
        self.overviewLabel = overviewLabel
    }
    
}
