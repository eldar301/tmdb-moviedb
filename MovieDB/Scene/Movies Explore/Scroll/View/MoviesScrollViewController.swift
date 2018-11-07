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
    
    private let spacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        presenter.view = self
        presenter.request()
        
        switch presenter.category {
        case .popular:
            self.navigationItem.title = "Popular"
            
        case .topRated:
            self.navigationItem.title = "Top Rated"
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        collectionView.refreshControl = refreshControl

        self.extendedLayoutIncludesOpaqueBars = true
        
        collectionView.register(UINib(nibName: "FullsizeMovieCell", bundle: nil), forCellWithReuseIdentifier: "fullsizeMovieCell")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fullsizeMovieCell", for: indexPath) as! FullsizeMovieCell
        
        let movie = movies[indexPath.row]
        
        cell.configure(withMovie: movie)
        
        return cell
    }
    
}

extension MoviesScrollViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 10 >= movies.count {
            presenter.requestNext()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset
        let availableWidth = collectionView.bounds.width - insets.left - insets.right
        if (indexPath.row + 1) % 3 == 0 {
            return CGSize(width: availableWidth, height: availableWidth * 1.5)
        } else {
            return CGSize(width: (availableWidth - spacing) / 2, height: (availableWidth - spacing) / 2 * 1.5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.showDetails(movie: movies[indexPath.row])
    }
    
}
