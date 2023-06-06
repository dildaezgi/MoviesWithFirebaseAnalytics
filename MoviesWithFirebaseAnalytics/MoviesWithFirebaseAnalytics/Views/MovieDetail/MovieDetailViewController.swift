//
//  MovieDetailViewController.swift
//  MoviesWithFirebaseAnalytics
//
//  Created by Dilda Ezgi Metincan Personal on 6.06.2023.
//

import UIKit
import FirebaseAnalytics

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieMinute: UILabel!
    @IBOutlet weak var movieStar: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    private let apiKey = "2232c59c"
    var movieID: String?
    var movie: MovieDetail?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        loadMovieDetails()
        logMovieDetailView(movieID: movieID ?? "")
    }
    
    func loadMovieDetails() {
        guard let movieID = movieID else {
            return
        }
        
        guard let url = URL(string: "http://www.omdbapi.com/?apikey=\(apiKey)&i=\(movieID)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Ağ hatası: \(error)")
                return
            }
            
            guard let data = data else {
                print("Veri alınamadı.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                
                DispatchQueue.main.async {
                    self.movieTitle.text = movieDetail.title
                    self.movieMinute.text = movieDetail.runtime
                    self.movieStar.text = movieDetail.imdbRating
                    self.movieYear.text = movieDetail.year
                    self.movieGenre.text = movieDetail.genre
                    self.movieDescription.text = movieDetail.plot
                    self.movieImage.imageFromURL(movieDetail.poster ?? "", placeholderImage: UIImage(named: "placeholder"))
                }
            } catch {
                print("Veri çözümleme hatası: \(error)")
            }
        }.resume()
    }
    
    func logMovieDetailView(movieID: String) {
        let parameters: [String: Any] = [
            "movieID": movieID
        ]
        Analytics.logEvent("movie_detail_view", parameters: parameters)
    }
}
