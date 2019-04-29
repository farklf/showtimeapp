//
//  FireViewModel.swift
//  ShowTimeApp
//
//  Created by mac on 4/24/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation



final class FireViewModel {
    
    static let shared = FireViewModel()
    private init() {}
    
    
    var favoritesID = Set<String>()
    
    
    var favorites = [Attraction]() {
        didSet {
            
            getFireIDs()
            NotificationCenter.default.post(name: Notification.Name.fireNotification, object: nil, userInfo: nil)
        }
    }
    

    func getFire() {
        
        FireService.shared.get { [unowned self] attrs in
            self.favorites = attrs
        }
    } //end func
    
    
    private func getFireIDs() {
        
        favorites.forEach({favoritesID.insert($0.id)})
        
//        for favorite in favorites {
//            favoritesID.insert(favorite.id)
//        }
//
        
    }
} //end class
