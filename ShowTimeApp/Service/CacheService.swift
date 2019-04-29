//
//  CacheService.swift
//  ShowTimeApp
//
//  Created by mac on 4/23/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

typealias ImageHandler = (UIImage?) -> Void

let cacheDL = CacheService.shared

final class CacheService {
    
    static let shared = CacheService()
    private init() {}
    
    let cache = NSCache<NSString, UIImage>()
    
    
    func downloadImage(with urlString: String, completion: @escaping ImageHandler) {
        
        if let image = cache.object(forKey: urlString as NSString) {
            completion(image)
            return
        }
      
        guard let url = URL(string: urlString) else {
            completion(nil)
            print("Bad URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (dat, _, _) in
            
            if let data = dat {
                
                guard let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                
                self.cache.setObject(image, forKey: urlString as NSString)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
    
    } //end func
    
    
    
} //end class
