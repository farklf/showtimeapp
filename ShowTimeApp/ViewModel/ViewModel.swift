//
//  ViewModel.swift
//  ShowTimeApp
//
//  Created by mac on 4/23/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

protocol AttrDelegate: class {
    func updateAttrs()
}


class ViewModel {
    
    weak var delegate: AttrDelegate?
    
    var attrs = [Attraction]() {
        didSet {
            delegate?.updateAttrs()
        }
    }
    
    
    var filteredAttrs = [Attraction]() {
        didSet {
            delegate?.updateAttrs()
        }
    }
    
    
    func get(with limit: String?) {
        
        TicketService.shared.getAttractions(with: limit) { [unowned self] attrs in
            sleep(1)
            self.attrs = attrs
            print("Attrs Count: \(self.attrs.count)")
        }
    }
    
    
} //end class
