//
//  UIColor+Extension.swift
//  ShowTimeApp
//
//  Created by mac on 4/24/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit


extension UIColor {
    
    static let customRed = UIColor.red.lighter(by: 25)
    static let gold = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
    
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
    
}



