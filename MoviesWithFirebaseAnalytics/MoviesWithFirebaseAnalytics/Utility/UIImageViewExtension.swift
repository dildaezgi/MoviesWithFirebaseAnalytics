//
//  UIImageViewExtension.swift
//  MoviesWithFirebaseAnalytics
//
//  Created by Dilda Ezgi Metincan Personal on 5.06.2023.
//

import Foundation
import UIKit

extension UIImageView {
    func imageFromURL(_ urlString: String, placeholderImage: UIImage? = nil) {
        guard let url = URL(string: urlString) else {
            self.image = placeholderImage
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.image = placeholderImage
                }
            }
        }
    }
}

