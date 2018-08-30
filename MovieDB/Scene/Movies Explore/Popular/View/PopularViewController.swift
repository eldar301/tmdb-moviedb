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
    
    var presenter: PopularPresenter!
    
    fileprivate var moviesCount: Int = 0
    
    fileprivate let spacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = PopularPresenterDefault(router: Router(viewController: self), moviesProvider: RemoteMoviesProvider(networkHelper: NetworkHelperDefault()))
        
        presenter.view = self
        presenter.refresh()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        collectionView.refreshControl = refreshControl

        self.extendedLayoutIncludesOpaqueBars = true
        
        collectionView.register(UINib(nibName: "PopularCell", bundle: nil), forCellWithReuseIdentifier: "popularCell")
        
//        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    @objc func refresh() {
        presenter.refresh()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        self.transitionCoordinator?.animate(alongsideTransition: { _ in
//            self.navigationController?.navigationBar.alpha = 0.0
//        })
//    }
    
}

extension PopularViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (navigationController?.viewControllers.count ?? 0) > 1
    }
    
}

extension PopularViewController: PopularView {
    
    func updateWithNewMovies() {
        self.collectionView.refreshControl?.endRefreshing()
        self.collectionView.reloadData()
        self.moviesCount = self.presenter.moviesCount
    }
    
    func updateWithAdditionalMovies() {
        let addIndexies = (self.moviesCount ..< self.presenter.moviesCount).map({ IndexPath(row: $0, section: 0) })
        self.moviesCount = self.presenter.moviesCount
        self.collectionView.insertItems(at: addIndexies)
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
        presenter.showDetails(ofMovieWithIndex: indexPath.row)
    }
    
}
