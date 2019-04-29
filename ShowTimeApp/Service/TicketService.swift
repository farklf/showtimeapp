//
//  TicketService.swift
//  ShowTimeApp
//
//  Created by mac on 4/23/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

typealias AttractionHandler = ([Attraction]) -> Void


final class TicketService {
    
    static let shared = TicketService()
    private init() {}
    
    
    func getAttractions(with limit: String?, completion: @escaping AttractionHandler ) {
        
        let urlString = TicketAPI.makeAttrURL(with: limit)
        let url = URL(string: urlString)!
        
        var attractions = [Attraction]()
        
        URLSession.shared.dataTask(with: url) { (eze, _ , _) in
            
            
            if let data = eze {
                
                do {
                    
                    let jsonObject = try JSONDecoder().decode(AttractionResult.self, from: data)
                    
                    for attr in jsonObject.embedded.attractions {
                        attractions.append(attr)
                    }
                    
                    completion(attractions)
                    
                } catch {
        
                    print("Couldn't decode: \(error.localizedDescription)")
                    completion([])
                }
            }
            
        }.resume()
        
        
        
    } //end func
    
    
} //end class
