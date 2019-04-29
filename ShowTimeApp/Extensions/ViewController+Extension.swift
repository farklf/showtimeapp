//
//  ViewController+Extension.swift
//  ShowTimeApp
//
//  Created by mac on 4/26/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit


extension UIViewController {
    
    
    func goToHome() {
        
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        let mainTC = storyboard.instantiateViewController(withIdentifier: "MainTabController") as! UITabBarController
        self.present(mainTC, animated: true, completion: nil)
        
    }
    
    
    func goToLogin() {
        
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        self.present(loginVC, animated: true, completion: nil)
    }
    
}
