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
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5.0
        
        self.backgroundColor = .clear
        
        imageView.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        label.text = nil
    }
    
    func configure(withConfigurator configurator: PopularCellConfigurator) {
        label.text = configurator.title
        
        imageView.sd_setImage(with: configurator.posterURL, placeholderImage: nil, options: []) { image, error, cacheType, imageURL in
            DispatchQueue.main.async { [weak self] in
                guard imageURL == configurator.posterURL else {
                    return
                }
                
                self?.imageView.image = image
            }
        }

    }

}
