//
//  EmptyViewViewController.swift
//  MoviesWithFirebaseAnalytics
//
//  Created by Dilda Ezgi Metincan Personal on 5.06.2023.
//

import UIKit

struct EmptyViewData {
    let image: String
    let title: String
    let description: String
}

enum EmptyViewType {
    case homePage, noData
    
    func data() -> EmptyViewData {
        switch self {
        case .homePage:
            return EmptyViewData(image: "https://static.thenounproject.com/png/505024-200.png",
                                 title: "Let's do it!",
                                 description: "Henüz bir arama yapmadınız")
        case .noData:
            return EmptyViewData(image: "https://static.thenounproject.com/png/4147389-200.png",
                                 title: "Ups!",
                                 description: "Bu filmi bulamadık")
        }
    }
}
@IBDesignable
class EmptyViewViewController: UIView, NibLoadable {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func bind(type: EmptyViewType) {
        let data = type.data()

        imagePoster.imageFromURL(data.image)
        titleLabel.text = data.title
        descriptionLabel.text = data.description
    }
}
