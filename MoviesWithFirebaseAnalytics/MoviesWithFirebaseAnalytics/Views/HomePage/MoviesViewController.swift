//
//  MoviesViewController.swift
//  MoviesWithFirebaseAnalytics
//
//  Created by Dilda Ezgi Metincan Personal on 5.06.2023.
//

import Foundation
import UIKit
import Lottie

class MoviesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movieViewModel = MovieViewModel()
    var searchResults: [MovieSearchResult] = []
    let emptyView = EmptyViewViewController()
    
    private var loadingAnimationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        emptyView.bind(type: .homePage)
        emptyView.frame = collectionView.bounds
        collectionView.addSubview(emptyView)
        setupLoadingAnimationView()
        collectionView.register(UINib(nibName: MovieCollectionViewCell.reuseID, bundle: nil), forCellWithReuseIdentifier: MovieCollectionViewCell.reuseID)
    }
    
    private func setupLoadingAnimationView() {
        let jsonName = "99257-loading-gif-animation"
        let animation = LottieAnimation.named(jsonName)
        loadingAnimationView = LottieAnimationView(animation: animation)
        let animationSize: CGFloat = 200
        let centerX = collectionView.bounds.width / 2
        let centerY = collectionView.bounds.height / 2
        let animationFrame = CGRect(x: centerX - (animationSize / 2), y: centerY - (animationSize / 2), width: animationSize, height: animationSize)
        loadingAnimationView?.frame = animationFrame
        view.addSubview(loadingAnimationView)
        loadingAnimationView.isHidden = true
    }
    
    private func startLoadingAnimation() {
        loadingAnimationView.isHidden = false
        loadingAnimationView?.play()
        loadingAnimationView.currentTime = 0.3
        let overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0.1
        view.addSubview(overlayView)
        
        if loadingAnimationView.isAnimationPlaying == false {
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                overlayView.alpha = 0.3
            }, completion: { _ in
                overlayView.removeFromSuperview()
            })
        } 
    }
    
    private func stopLoadingAnimation() {
        loadingAnimationView.isHidden = true
        loadingAnimationView?.stop()
    }
      
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseID, for: indexPath) as? MovieCollectionViewCell else {
            fatalError("Unable to dequeue MovieCollectionViewCell")
        }

        let movie = searchResults[indexPath.item]
        cell.bind(with: movie)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let spacing: CGFloat = 10
        let cellWidth = (collectionViewWidth - spacing) / 2.0
        let cellHeight = collectionView.bounds.height / 3.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "MovieDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController
        {
            vc.movieID = searchResults[indexPath.row].imdbID
            present(vc, animated: true, completion: nil)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            emptyView.isHidden = false
            emptyView.bind(type: .homePage)
            emptyView.frame = collectionView.bounds
            collectionView.addSubview(emptyView)
            stopLoadingAnimation()
        } else if searchText.count >= 3 {
            startLoadingAnimation()
            let searchTerm = searchText.replacingOccurrences(of: " ", with: "+")
            movieViewModel.fetchSearchResults(searchTerm: searchTerm) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let searchResults):
                        if searchResults.isEmpty {
                            self.emptyView.isHidden = false
                            self.emptyView.bind(type: .noData)
                            self.emptyView.frame = self.collectionView.bounds
                            self.collectionView.addSubview(self.emptyView)
                        } else {
                            self.emptyView.isHidden = true
                            self.searchResults = searchResults
                            self.collectionView.isHidden = false
                            self.collectionView.reloadData()
                        }
                    case .failure(let error):
                        self.emptyView.isHidden = false
                        self.emptyView.bind(type: .noData)
                        self.emptyView.frame = self.collectionView.bounds
                        self.collectionView.addSubview(self.emptyView)
                        print("Error: \(error)")
                    }
                    self.stopLoadingAnimation()
                }
            }
        } else {
            emptyView.isHidden = false
            emptyView.bind(type: .homePage)
            emptyView.frame = collectionView.bounds
            collectionView.addSubview(emptyView)
            stopLoadingAnimation()
        }
    }
}
