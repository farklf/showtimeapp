//
//  AttractionCollectionCell.swift
//  ShowTimeApp
//
//  Created by mac on 4/23/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class AttractionCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var attractionCollectionImage: UIImageView!
    
    
    static let identifier = "CollectionOne"
    
    
    func configureCollection(with attr: Attraction) {
        
        let image = attr.images.first(where: { $0.ratio == "16_9" })
        
        guard let urlString = image?.url else {
            return
        }
        
        cacheDL.downloadImage(with: urlString) { [unowned self] image in
            if let img = image {
                self.attractionCollectionImage.image = img
            }
        }
        
        
    } //end func 
    
}
