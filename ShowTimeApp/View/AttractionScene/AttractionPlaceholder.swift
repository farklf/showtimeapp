//
//  AttractionPlaceholder.swift
//  ShowTimeApp
//
//  Created by mac on 4/25/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class AttractionPlaceholder: UIView {

    
    class func instanceFromNib() -> AttractionPlaceholder {
        return UINib(nibName: "AttractionPlaceholder", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AttractionPlaceholder
    }


}
