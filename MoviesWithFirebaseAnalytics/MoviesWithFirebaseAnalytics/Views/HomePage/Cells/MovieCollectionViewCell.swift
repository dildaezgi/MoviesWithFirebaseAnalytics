//
//  MovieCollectionViewCell.swift
//  MoviesWithFirebaseAnalytics
//
//  Created by Dilda Ezgi Metincan Personal on 5.06.2023.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let identifier = "movieCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(with movie: MovieSearchResult) {
        if let title = movie.title {
            titleLabel.text = title
        } else {
            print("yok title")
        }
        
        movieImageView.imageFromURL(movie.poster ?? "", placeholderImage: UIImage(named: "placeholder-image"))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        movieImageView.image = nil 
    }
}

