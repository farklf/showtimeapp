//
//  AttractionTableCell.swift
//  ShowTimeApp
//
//  Created by mac on 4/23/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class AttractionTableCell: UITableViewCell {

    @IBOutlet weak var attractionCollectionView: UICollectionView!
    
    @IBOutlet weak var attractionImage: UIImageView!
    @IBOutlet weak var attractionLabel: UILabel!
    @IBOutlet weak var attractionSubLabel: UILabel!
    
    @IBOutlet weak var attractionFavoriteButton: UIButton!
    
    
    
    static let identifiers = ["AttractionOne", "AttractionTwo"]
    
    
    func configureTable(with attr: Attraction) {
        
        attractionLabel.text = attr.name
        attractionSubLabel.text = attr.classifications.first!.genre.name
        
        let image = attr.images.first(where: {$0.ratio == "16_9"})
        
        guard let urlString = image?.url else {
            return
        }
        
        cacheDL.downloadImage(with: urlString) { [unowned self] image in
            if let img = image {
                self.attractionImage?.image = img
            }
        }
        
        
    } //end func
    
    
    
} //end class
