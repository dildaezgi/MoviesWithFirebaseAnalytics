//
//  MoviesViewController.swift
//  MoviesWithFirebaseAnalytics
//
//  Created by Dilda Ezgi Metincan Personal on 5.06.2023.
//

import Foundation
import UIKit

class MoviesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movieViewModel = MovieViewModel()
    var searchResults: [MovieSearchResult] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self

        collectionView.register(UINib(nibName: MovieCollectionViewCell.reuseID, bundle: nil), forCellWithReuseIdentifier: MovieCollectionViewCell.reuseID)
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            movieViewModel.fetchSearchResults(searchTerm: searchText) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let searchResults):
                        self?.searchResults = searchResults
                        self?.collectionView.reloadData()
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            }
        }
    }
}
