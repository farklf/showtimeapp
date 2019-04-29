//
//  Attraction.swift
//  ShowTimeApp
//
//  Created by mac on 4/23/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct AttractionResult: Decodable {
    let embedded: AttractionInfo
    
    private enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}

struct AttractionInfo: Decodable {
    let attractions: [Attraction]
}


class Attraction: Decodable {
    
    let name: String
    let id: String
    let url: String
    let images: [Image]
    let classifications: [Classification]
    
    
    //JSON Initializer
    init(name: String, id: String, url: String, images: [Image], classifications: [Classification]) {
        
        self.name = name
        self.id = id
        self.url = url
        self.images = images
        self.classifications = classifications
    }
    
    //Firebase Initializer
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String:Any] else {
            return nil
        }
        
        self.name = value[Constants.name] as! String
        self.url = value[Constants.url] as! String
        self.id = value[Constants.id] as! String
        
        let imageURL = value[Constants.image] as! String
        let genreName = value[Constants.genre] as! String
        
        
        self.images = [Image(url: imageURL, ratio: "16_9")]
        self.classifications = [Classification(genre: Genre(name: genreName))]
    }
}

//MARK: Images

struct Image: Decodable {
    
    let url: String
    let ratio: String
}

//MARK: Genre

struct Classification: Decodable {
    
    let genre: Genre

}


struct Genre: Decodable {
    
    let name: String
}


extension Attraction: Equatable {
    
    static func ==(lhs: Attraction, rhs: Attraction) -> Bool {
        return lhs.id == rhs.id
    }
}
