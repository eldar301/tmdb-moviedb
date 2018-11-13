//
//  PopularViewController.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 21/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class MoviesScrollViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: MoviesScrollPresenter!
    
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        presenter.view = self
        presenter.request()
        
        switch presenter.category {
        case .popular:
            self.navigationItem.title = Constants.Strings.popular
            
        case .topRated:
            self.navigationItem.title = Constants.Strings.topRated
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = Constants.CollectionView.contentInset
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        collectionView.refreshControl = refreshControl

        self.extendedLayoutIncludesOpaqueBars = true
        
        collectionView.register(Constants.UINibs.movieCellNib, forCellWithReuseIdentifier: Constants.Strings.movieCellReuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc func refresh() {
        presenter.request()
    }
    
}

extension MoviesScrollViewController: MoviesExploreView {
    
    func updateWithNewMovies(movies: [Movie]) {
        self.movies = movies
        self.collectionView.refreshControl?.endRefreshing()
        self.collectionView.reloadData()
    }
    
    func updateWithAdditionalMovies(movies: [Movie]) {
        let addIndices = (self.movies.count ..< movies.count).map({ IndexPath(row: $0, section: 0) })
        self.movies = movies
        self.collectionView.insertItems(at: addIndices)
    }
    
    func showError(description: String) {
        print(description)
    }
    
}

extension MoviesScrollViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Strings.movieCellReuseIdentifier, for: indexPath) as! FullsizeMovieCell
        
        let movie = movies[indexPath.row]
        cell.configure(withMovie: movie)
        
        return cell
    }
    
}

extension MoviesScrollViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + Constants.CollectionView.requestAdditionalMoviesWhenLeftCount >= movies.count {
            presenter.requestNext()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.CollectionView.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset
        let availableWidth = collectionView.bounds.width - insets.left - insets.right
        if (indexPath.row + 1) % 3 == 0 {
            return CGSize(width: availableWidth,
                          height: availableWidth * Constants.CollectionView.cellSizeRatio)
        } else {
            let width = (availableWidth - Constants.CollectionView.spacing) / 2.0
            return CGSize(width: width,
                          height: width * Constants.CollectionView.cellSizeRatio)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.showDetails(movie: movies[indexPath.row])
    }
    
}

fileprivate struct Constants {
    struct UINibs {
        static let movieCellNib = UINib(nibName: "FullsizeMovieCell", bundle: nil)
    }
    struct Strings {
        static let movieCellReuseIdentifier = "fullsizeMovieCell"
        static let popular = NSLocalizedString("Popular", comment: #file)
        static let topRated = NSLocalizedString("Top Rated", comment: #file)
    }
    struct CollectionView {
        static let contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        static let spacing: CGFloat = 10.0
        static let cellSizeRatio: CGFloat = 1.5
        static let requestAdditionalMoviesWhenLeftCount = 10
    }
}
