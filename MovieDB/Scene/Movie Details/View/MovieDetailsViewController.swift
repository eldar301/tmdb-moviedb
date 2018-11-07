//
//  MovieDetailsViewController.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 22/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backdropHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var watchTrailerSectionHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var reviewsSectionHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var castSectionHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backdropImageView: UIImageView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ratingView: RatingView!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var reviewsCollectionView: UICollectionView!
    
    @IBOutlet weak var castsCollectionView: UICollectionView!
    
    @IBOutlet weak var watchTrailerButton: UIButton!
    
    @IBOutlet weak var releasedLabel: UILabel!
    
    @IBOutlet weak var genresLabel: UILabel!
    
    @IBOutlet weak var runtimeLabel: UILabel!
    
    @IBOutlet weak var budgetLabel: UILabel!
    
    var presenter: MovieDetailsPresenter!
    
    private var reviews: [Review] = []
    private var casts: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        presenter.request()
        
        titleLabel.adjustsFontSizeToFitWidth = true
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8.0
        
        backdropImageView.contentMode = .scaleAspectFill
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        watchTrailerButton.layer.cornerRadius = 12.0
        
        scrollView.delegate = self
        
        reviewsCollectionView.delegate = self
        reviewsCollectionView.dataSource = self
        reviewsCollectionView.decelerationRate = .fast
        
        castsCollectionView.delegate = self
        castsCollectionView.dataSource = self
        
        reviewsCollectionView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellWithReuseIdentifier: "reviewCell")
        
        castsCollectionView.register(UINib(nibName: "CastCell", bundle: nil), forCellWithReuseIdentifier: "castCell")
        
        let headerBlurView = AdvancedBlurView(effect: UIBlurEffect(style: .light), intensity: 0.1)
        headerBlurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        headerBlurView.frame = backdropImageView.bounds
        backdropImageView.addSubview(headerBlurView)
        
        let gradientView = GradientView()
        gradientView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        gradientView.frame = backdropImageView.bounds
        backdropImageView.addSubview(gradientView)
        
        let gradientLayer = gradientView.gradientLayer
        let color = self.view.backgroundColor!
        gradientLayer.colors = [color.withAlphaComponent(0.5).cgColor,
                                color.cgColor]
        gradientLayer.locations = [0.0, 0.8]
        gradientLayer.frame = headerBlurView.bounds
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let closeButton = UIButton()
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.tintColor = .white
        closeButton.sizeToFit()
        closeButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        closeButton.layer.cornerRadius = closeButton.bounds.height / 2.0
        closeButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        self.navigationItem.rightBarButtonItem = closeBarButton
    }
    
    @objc func close() {
        presenter.dismiss()
    }

}

extension MovieDetailsViewController: MovieDetailsView {
    
    func update(detailsConfigurator: DetailsConfigurator, reviews: [Review], casts: [Person]) {
        DispatchQueue.main.async {
            self.updateData(detailsConfigurator: detailsConfigurator, reviews: reviews, casts: casts)
        }
    }
    
    private func updateData(detailsConfigurator: DetailsConfigurator, reviews: [Review], casts: [Person]) {
        backdropImageView.sd_setImage(with: detailsConfigurator.backdropURL)
        posterImageView.sd_setImage(with: detailsConfigurator.posterURL)
        
        titleLabel.text = detailsConfigurator.title
        overviewLabel.text = detailsConfigurator.overview
        
        ratingView.rating = CGFloat(detailsConfigurator.voteAverage ?? 0.0)
        ratingView.votesCount = detailsConfigurator.voteCount ?? 0
        
        if detailsConfigurator.trailerURL == nil {
            watchTrailerSectionHeightConstraint.constant = 0
        } else {
            watchTrailerSectionHeightConstraint.constant = 52
        }
        
        releasedLabel.text = detailsConfigurator.releaseDate ?? "-"
        
        runtimeLabel.text = detailsConfigurator.runtime ?? "-"
        
        genresLabel.text = detailsConfigurator.genres?.joined(separator: "\r") ?? "-"
        
        budgetLabel.text = detailsConfigurator.budget ?? "-"
        
        self.reviews = reviews
        if reviews.count != 0 {
            reviewsCollectionView.reloadData()
            reviewsSectionHeightConstraint.constant = 279
        } else {
            reviewsSectionHeightConstraint.constant = 0
        }
        
        self.casts = casts
        if casts.count != 0 {
            castsCollectionView.reloadData()
            castSectionHeightConstraint.constant = 170
        } else {
            castSectionHeightConstraint.constant = 0
        }
    }
    
    func showError(description: String) {
        print(description)
    }
    
}

extension MovieDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === reviewsCollectionView {
            return reviews.count
        } else {
            return casts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === reviewsCollectionView {
            let cell = reviewsCollectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! ReviewCell
            
            let review = reviews[indexPath.row]
            cell.configure(review: review)
            
            return cell
        } else {
            let cell = castsCollectionView.dequeueReusableCell(withReuseIdentifier: "castCell", for: indexPath) as! CastCell
            
            let cast = casts[indexPath.row]
            cell.configure(cast: cast)
            
            return cell
        }
    }
    
}

extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView === reviewsCollectionView {
            let height = reviewsCollectionView.bounds.height - 16.0
            let width = reviewsCollectionView.bounds.width - 16.0
            
            return CGSize(width: width, height: height)
        } else {
            let size = castsCollectionView.bounds.height
            
            return CGSize(width: size, height: size)
        }
    }
    
}

extension MovieDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView === reviewsCollectionView else {
            return
        }
        
        let layout = reviewsCollectionView.collectionViewLayout
        let bounds = reviewsCollectionView.bounds
        
        if abs(velocity.x) <= 0.3 {
            let currentCenter = bounds.midX
            let attributes = layout.layoutAttributesForElements(in: bounds)
            if let nearestToCurrentCenter = attributes?.min(by: { abs($0.center.x - currentCenter) < abs($1.center.x - currentCenter) }) {
                targetContentOffset.pointee.x = nearestToCurrentCenter.frame.origin.x
            }
        } else if velocity.x > 0 {
            let attributes = layout.layoutAttributesForElements(in: bounds.offsetBy(dx: bounds.width, dy: 0))
            if let rightAttribute = attributes?.min(by: { $0.frame.origin.x < $1.frame.origin.x }) {
                targetContentOffset.pointee.x = rightAttribute.frame.origin.x
            }
        } else {
            let attributes = layout.layoutAttributesForElements(in: bounds.offsetBy(dx: -bounds.width, dy: 0))
            if let leftAttribute = attributes?.max(by: { $0.frame.origin.x < $1.frame.origin.x }) {
                targetContentOffset.pointee.x = leftAttribute.frame.origin.x
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === self.scrollView else {
            return
        }
        
        let offset = -scrollView.contentOffset.y + 50.0
        if offset > 50 {
            backdropHeightConstraint.constant = 230 + offset
        } else {
            backdropHeightConstraint.constant = 280
        }
    }
    
}
