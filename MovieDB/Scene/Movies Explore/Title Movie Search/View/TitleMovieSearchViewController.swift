//
//  TitleMovieSearchViewController.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 05/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class TitleMovieSearchViewController: UICollectionViewController {
    
    var presenter: TitleMovieSearchPresenter!
    
    fileprivate var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self

//        self.extendedLayoutIncludesOpaqueBars = true
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//
        self.collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
    }
    
    override func loadView() {
        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.backgroundColor = UIColor(red: 18.0 / 255.0,
                                                      green: 27.0 / 250.0,
                                                      blue: 36.0 / 255.0,
                                                      alpha: 1.0)
    }
    
    func search(title: String) {
        presenter.search(title: title)
    }
    
}

extension TitleMovieSearchViewController: MoviesExploreView {
    
    func updateWithNewMovies(movies: [Movie]) {
        self.movies = movies
        if !movies.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
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

extension TitleMovieSearchViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies[indexPath.row]
        
        cell.configure(withMovie: movie)
        
        return cell
    }
    
}

extension TitleMovieSearchViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.showDetails(movie: movies[indexPath.row])
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 4 >= movies.count {
            presenter.searchNext()
        }
    }
    
}

extension TitleMovieSearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 650.0)
    }
}
