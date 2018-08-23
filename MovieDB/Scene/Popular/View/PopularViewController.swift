//
//  PopularViewController.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 21/08/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class PopularViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let presenter: PopularPresenter = PopularPresenterDefault(popularMoviesProvider: RemotePopularMoviesProvider(networkHelper: NetworkHelperDefault()))
    
    fileprivate var moviesCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        collectionView.refreshControl = refreshControl
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        collectionView.register(UINib(nibName: "PopularCell", bundle: nil), forCellWithReuseIdentifier: "popularCell")
        
        presenter.refresh()
        
        back = navigationController?.navigationBar.backgroundImage(for: .default)
    }
    
    var back: UIImage?
    
    @objc func refresh() {
        presenter.refresh()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.navigationController?.navigationBar.alpha = 0.0
        })
    }
    
}

extension PopularViewController: PopularView {
    
    func updateWithNewData() {
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
            self.moviesCount = self.presenter.moviesCount
        }
    }
    
    func updateWithAdditionalData() {
        let addIndexies = (moviesCount ..< presenter.moviesCount).map({ IndexPath(row: $0, section: 0) })
        moviesCount = presenter.moviesCount
        DispatchQueue.main.async {
            self.collectionView.insertItems(at: addIndexies)
        }
    }
    
    func showError(description: String) {
        print(description)
    }
    
}

extension PopularViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularCell", for: indexPath) as! PopularCell
        
        let configurator = presenter.configurator(forIndex: indexPath.row)
        
        cell.configure(withConfigurator: configurator)
        
        return cell
    }
    
}

extension PopularViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 10 >= presenter.moviesCount {
            presenter.requestNext()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset
        let availableWidth = collectionView.bounds.width - insets.left - insets.right - 10
        if (indexPath.row + 1) % 3 == 0 {
            return CGSize(width: availableWidth + 10, height: availableWidth + 10)
        } else {
            return CGSize(width: availableWidth / 2, height: availableWidth / 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.showDetails(ofMovieWithIndex: indexPath.row)
        let controller = UIStoryboard(name: "MovieDetailsStoryboard", bundle: nil).instantiateInitialViewController()!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}


