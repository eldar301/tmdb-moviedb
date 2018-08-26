//
//  MovieDetailsViewController.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 22/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backdropHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backdropImageView: UIImageView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var reviewsCollectionView: UICollectionView!
    
    @IBOutlet weak var castsCollectionView: UICollectionView!
    
    @IBOutlet weak var watchTrailerButton: UIButton!
    
    @IBOutlet weak var releasedCaptionLabel: UILabel!
    @IBOutlet weak var releasedLabel: UILabel!
    
    @IBOutlet weak var genreCaptionLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var runtimeCaptionLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    
    @IBOutlet weak var budgetCaptionLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    
    fileprivate let presenter = MovieDetailsPresenterDefault(movie: PopularPresenterDefault.movie, movieDetailsProvider: RemoteMovieDetailsProvider(networkHelper: NetworkHelperDefault()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        presenter.request()
        
        titleLabel.adjustsFontSizeToFitWidth = true
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 8.0
        
        backdropImageView.contentMode = .scaleAspectFill
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        watchTrailerButton.layer.cornerRadius = 12.0
        
        scrollView.delegate = self
        
        reviewsCollectionView.delegate = self
        reviewsCollectionView.dataSource = self
        reviewsCollectionView.isScrollEnabled = false
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeReviewRight))
        rightSwipeGestureRecognizer.direction = .right
        reviewsCollectionView.addGestureRecognizer(rightSwipeGestureRecognizer)
        
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeReviewLeft))
        leftSwipeGestureRecognizer.direction = .left
        reviewsCollectionView.addGestureRecognizer(leftSwipeGestureRecognizer)
        
        castsCollectionView.delegate = self
        castsCollectionView.dataSource = self
        
        reviewsCollectionView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellWithReuseIdentifier: "reviewCell")
        
        castsCollectionView.register(UINib(nibName: "CastCell", bundle: nil), forCellWithReuseIdentifier: "castCell")
        
        let headerBlurView = AdvancedBlurView(effect: UIBlurEffect(style: .light), intensity: 0.1)
        headerBlurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        headerBlurView.frame = backdropImageView.bounds
        backdropImageView.addSubview(headerBlurView)
        
        let gradientLayer = CAGradientLayer()
        let color = self.view.backgroundColor!
        gradientLayer.colors = [color.withAlphaComponent(0.5).cgColor,
                                color.cgColor]
        gradientLayer.locations = [0.0, 0.8]
        gradientLayer.frame = backdropImageView.bounds
        headerBlurView.addLayer(layer: gradientLayer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.navigationController?.navigationBar.alpha = 1.0
        })
    }
    
    var centerAlignedIndex = 0
    
    @objc func swipeReviewRight() {
        if centerAlignedIndex > 0 {
            centerAlignedIndex -= 1
            reviewsCollectionView.scrollToItem(at: IndexPath(row: centerAlignedIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc func swipeReviewLeft() {
        if centerAlignedIndex < presenter.reviewsCount - 1 {
            centerAlignedIndex += 1
            reviewsCollectionView.scrollToItem(at: IndexPath(row: centerAlignedIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
}

extension MovieDetailsViewController: MovieDetailsView {
    
    func update() {
        let details = presenter.detailsConfigurator()
        print(details)
        
        backdropImageView.sd_setImage(with: details.backdropURL)
        posterImageView.sd_setImage(with: details.posterURL)
        
        titleLabel.text = details.title
        overviewLabel.text = details.overview
        
        if let releaseDate = details.releaseDate {
            releasedLabel.text = details.releaseDate
        }
        
        runtimeLabel.text = details.runtime
        
        genreLabel.text = details.genres?.joined(separator: "\r")
        
        budgetLabel.text = details.budget
        
        reviewsCollectionView.reloadData()
        castsCollectionView.reloadData()
    }
    
    func showError(description: String) {
        print(description)
    }
    
}

extension MovieDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === reviewsCollectionView {
            return presenter.reviewsCount
        } else {
            return presenter.castsCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === reviewsCollectionView {
            let cell = reviewsCollectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! ReviewCell
            
            let configurator = presenter.reviewConfigurator(forIndex: indexPath.row)
            cell.configure(withConfigurator: configurator)
            
            return cell
        } else {
            let cell = castsCollectionView.dequeueReusableCell(withReuseIdentifier: "castCell", for: indexPath) as! CastCell
            
            let configurator = presenter.castConfigurator(forIndex: indexPath.row)
            cell.configure(withConfigurator: configurator)
            
            return cell
        }
    }
    
}

extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView === reviewsCollectionView {
            let height = reviewsCollectionView.bounds.height - 16.0
            let width = reviewsCollectionView.bounds.width - 18.0
            
            return CGSize(width: width, height: height)
        } else {
            let size = castsCollectionView.bounds.height
            
            return CGSize(width: size, height: size)
        }
    }
    
}

extension MovieDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === self.scrollView {
            let offset = -scrollView.contentOffset.y + 25
            if offset > 0 {
                backdropHeightConstraint.constant = 340 + offset
            } else {
                backdropHeightConstraint.constant = 340
            }
        }
    }
    
}
