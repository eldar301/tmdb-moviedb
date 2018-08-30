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

class PopularCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
//    fileprivate var requestedPosterImageURL: URL?
    
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
    }
    
    func configure(withConfigurator configurator: PopularCellConfigurator) {
        titleLabel.text = configurator.title
//        titleLabel.te
        
//        requestedPosterImageURL = configurator.posterURL

//        posterImageView.sd_setImage(with: configurator.posterURL)
        posterImageView.sd_setImage(with: configurator.posterURL, placeholderImage: nil, options: []) { image, error, cacheType, imageURL in
            self.titleLabel.text = nil
        }

    }

}
