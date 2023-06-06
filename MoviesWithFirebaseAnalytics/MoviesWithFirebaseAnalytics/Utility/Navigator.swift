//
//  Navigator.swift
//  MoviesWithFirebaseAnalytics
//
//  Created by Dilda Ezgi Metincan Personal on 6.06.2023.
//

import Foundation
import UIKit

class Navigator: UINavigationController {
    var navController: UINavigationController?
    
    func navigateTo(_ viewController: UIViewController, animated: Bool) {
        navController?.pushViewController(viewController, animated: animated)
    }
    
    func back(animated: Bool) {
        navController?.popViewController(animated: animated)
    }
}
