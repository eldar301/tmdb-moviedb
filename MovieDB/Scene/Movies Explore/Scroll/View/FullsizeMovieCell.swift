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

fileprivate struct Constants {
    static let cornerRadius: CGFloat = 8.0
}

class FullsizeMovieCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    private var posterURL: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = Constants.cornerRadius
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterURL = nil
        posterImageView.image = nil
        posterImageView.sd_cancelCurrentImageLoad()

        titleLabel.text = nil
    }
    
    func configure(withMovie movie: Movie) {
        titleLabel.text = movie.title
        
        let posterURL = movie.posterURL ?? movie.backdropURL
        self.posterURL = posterURL
        posterImageView.sd_setImage(with: posterURL) { [weak self] _, error, _, _ in
            guard error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                guard posterURL == self?.posterURL else {
                    return
                }
                
                self?.titleLabel.text = nil
            }
        }

    }

}
