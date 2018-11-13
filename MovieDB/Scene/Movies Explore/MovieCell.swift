//
//  MovieCell.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 05/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit
import SDWebImage

class MovieCell: UITableViewCell {
    
    private weak var titleLabel: UILabel!
    private weak var posterImageView: UIImageView!
    private weak var ratingView: RatingView!
    private weak var overviewLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
        ratingView.rating = CGFloat(movie.voteAverage ?? 0.0)
        ratingView.votesCount = movie.voteCount ?? 0
    
        overviewLabel.text = movie.overview
        
        self.setNeedsLayout()
    }
    
    private func setup() {
        self.backgroundColor = Constants.View.backgroundColor
        self.layer.cornerRadius = Constants.View.cornerRadius
        
        let titleLabel = UILabel()
        titleLabel.font = Constants.TitleLabel.font
        titleLabel.textColor = .white
        titleLabel.backgroundColor = Constants.View.backgroundColor
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let posterImageView = UIImageView()
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(posterImageView)
        self.posterImageView = posterImageView
        
        let ratingView = RatingView()
        ratingView.backgroundColor = Constants.View.backgroundColor
        ratingView.votesLabelFontSize = Constants.RatingView.fontSize
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(ratingView)
        self.ratingView = ratingView
        
        let overviewLabel = UILabel()
        overviewLabel.font = Constants.OverviewLabel.font
        overviewLabel.textColor = .white
        overviewLabel.backgroundColor = Constants.View.backgroundColor
        overviewLabel.textAlignment = .justified
        overviewLabel.numberOfLines = 0
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(overviewLabel)
        self.overviewLabel = overviewLabel
        
        let margins = self.contentView.layoutMarginsGuide
        
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: Constants.TitleLabel.height).isActive = true
        
        posterImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        posterImageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor).isActive = true
        
        ratingView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: Constants.Margins.default).isActive = true
        ratingView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        ratingView.heightAnchor.constraint(equalToConstant: Constants.RatingView.height).isActive = true
        ratingView.height = Constants.RatingView.height
        
        overviewLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: Constants.Margins.default).isActive = true
        overviewLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        overviewLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        overviewLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
}

fileprivate struct Constants {
    struct View {
        static let backgroundColor = UIColor(red: 0.11, green: 0.12, blue: 0.16, alpha: 1.0)
        static let cornerRadius: CGFloat = 10.0
    }
    struct Margins {
        static let `default`: CGFloat = 8.0
    }
    struct TitleLabel {
        static let font = UIFont(name: "AvenirNext-DemiBold", size: 23.0)
        static let height: CGFloat = 55.0
    }
    struct RatingView {
        static let fontSize: CGFloat = 18.0
        static let height: CGFloat = 22.0
    }
    struct OverviewLabel {
        static let font = UIFont(name: "AvenirNext-Regular", size: 15.0)
    }
}
