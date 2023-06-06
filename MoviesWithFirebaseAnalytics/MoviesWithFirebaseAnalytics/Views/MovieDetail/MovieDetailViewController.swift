//
//  MovieDetailViewController.swift
//  MoviesWithFirebaseAnalytics
//
//  Created by Dilda Ezgi Metincan Personal on 6.06.2023.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    private let apiKey = "2232c59c"
    var movieID: String?
    var movie: MovieDetail?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        loadMovieDetails()
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
                    self.movieDescription.text = movieDetail.plot
                    self.movieImage.imageFromURL(movieDetail.poster ?? "", placeholderImage: UIImage(named: "placeholder"))
                }
            } catch {
                print("Veri çözümleme hatası: \(error)")
            }
        }.resume()
    }


}
