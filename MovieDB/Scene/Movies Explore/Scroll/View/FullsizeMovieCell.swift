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
        
        self.posterURL = movie.posterURL ?? movie.backdropURL
        posterImageView.sd_setImage(with: posterURL, placeholderImage: nil, options: []) { [weak self] image, _, _, imageURL in
            guard let self = self else {
                return
            }
        
            var roundedImage: UIImage?
            let size = self.posterImageView.bounds.size
            let backgroundColor = self.backgroundColor!.cgColor
            
            let roundingTask = DispatchWorkItem(block: {
                roundedImage = image?.rounded(forSize: size, withCornerRadius: Constants.cornerRadius, backgroundColor: backgroundColor)
            })
            DispatchQueue.global().async(execute: roundingTask)
            
            roundingTask.notify(queue: .main, execute: { [weak self] in
                guard self?.posterURL == imageURL else {
                    return
                }
                
                self?.posterImageView.image = roundedImage
                self?.titleLabel.text = nil
            })
        }

    }

}
