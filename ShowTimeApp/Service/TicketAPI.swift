//
//  TicketAPI.swift
//  ShowTimeApp
//
//  Created by mac on 4/23/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation


struct TicketAPI {
    
    
    static let base = "https://app.ticketmaster.com/discovery/v2/"
    static let attr = "attractions.json?countryCode=US&size="
    static let key = "&apikey=q4XbCAgXoPg3Ns8reAHrQN3NUO1NJxtq"
    
    static func makeAttrURL(with limit: String?) -> String {
        
        if let lmt = limit {
            
            return base + attr + lmt + key
        }
        
        return base + attr + "40" + key
    }
    
}
