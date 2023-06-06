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
        
        guard let url = URL(string: "https://www.omdbapi.com/?i=\(movieID)&apikey=\(apiKey)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Hata kontrolü yapın.
            if let error = error {
                print("Ağ hatası: \(error)")
                return
            }
            
            // Veriyi kontrol edin.
            guard let data = data else {
                print("Veri alınamadı.")
                return
            }
            
            do {
                // JSON'u `MovieDetail` modeline çevirin.
                let decoder = JSONDecoder()
                let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                
                // Ana iş parçacığına dönün ve UI'ı güncelleyin.
                DispatchQueue.main.async {
                    self.movieTitle.text = movieDetail.title
                    self.movieDescription.text = movieDetail.actors
                    // UI güncelleme kodunu buraya yazın.
                    // Örneğin:
                    // self.titleLabel.text = movieDetail.title
                    // self.directorLabel.text = movieDetail.director
                    // ...
                }
            } catch {
                print("Veri çözümleme hatası: \(error)")
            }
        }.resume()  // İsteği başlatmak için `resume` metodu çağırılmalıdır.
    }


}
