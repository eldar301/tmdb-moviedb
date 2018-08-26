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
    
    fileprivate var requestedProfileImageURL: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = nil
        nameLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configure(withConfigurator configurator: CastCellConfigurator) {
        nameLabel.text = configurator.name
        
        requestedProfileImageURL = configurator.profileImageURL
        
        profileImageView.sd_setImage(with: requestedProfileImageURL) { image, error, cacheType, url in
            DispatchQueue.main.async { [weak self] in
                guard url == self?.requestedProfileImageURL else {
                    return
                }
                
                self?.profileImageView.image = image
            }
        }
    }

}
