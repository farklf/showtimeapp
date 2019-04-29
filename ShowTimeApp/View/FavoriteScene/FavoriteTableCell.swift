//
//  FavoriteTableCell.swift
//  ShowTimeApp
//
//  Created by mac on 4/24/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class FavoriteTableCell: UITableViewCell {

    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var favoriteMainLabel: UILabel!
    @IBOutlet weak var favoriteSubLabel: UILabel!
    

    static let identifier = "FavoriteOne"
    
    func configureFavorite(with attr: Attraction) {
        
        favoriteMainLabel.text = attr.name
        favoriteSubLabel.text = attr.classifications.first!.genre.name
        
        let imageURL = attr.images.first!.url
        
        cacheDL.downloadImage(with: imageURL) { [unowned self] img in
            if let image = img {
                self.favoriteImage.image = image
            }
        }
    } //end func
    
    
} //end class
