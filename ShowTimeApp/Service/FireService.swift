//
//  FireService.swift
//  ShowTimeApp
//
//  Created by mac on 4/24/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth



final class FireService {
    
    static let shared = FireService()
    private init() {}
    
    
    let uid = Auth.auth().currentUser?.uid
    lazy var userRef = Database.database().reference(withPath: uid ?? "user")
    lazy var attrRef = userRef.child(Constants.attractions)
    
    
    //MARK: Save, Delete, Get Attractions
    func save(_ attr: Attraction) {
        
        attrRef.child(attr.id).child(Constants.name).setValue(attr.name)
        attrRef.child(attr.id).child(Constants.url).setValue(attr.url)
        attrRef.child(attr.id).child(Constants.id).setValue(attr.id)
        
        
        let ratio = attr.images.first(where: {$0.ratio == "16_9"})
        let imageURL = ratio!.url
        attrRef.child(attr.id).child(Constants.image).setValue(imageURL)
        
        
        let genre = attr.classifications.first!.genre.name
        attrRef.child(attr.id).child(Constants.genre).setValue(genre)
        
        
        print("Saved Attraction: \(attr.name)")
    }
    
    
    func remove(_ attr: Attraction) {
        
        attrRef.child(attr.id).removeValue()
        
        print("Removed Attraction: \(attr.name)")
        
    }
    
    
    func get(firebase completion: @escaping AttractionHandler) {
        
        var attractions = [Attraction]()
        
        
        attrRef.observeSingleEvent(of: .value) { snapshot in
            
            for snap in snapshot.children {
                
                let data: DataSnapshot = snap as! DataSnapshot
                
                //initialize the attr from the data
                guard let attr = Attraction(snapshot: data) else {
                    continue
                }
                //append attr to attractions
                attractions.append(attr)
            }
        
            //return in completion
            completion(attractions)
        }
    } //end func
    
    
    
    
} //end class


