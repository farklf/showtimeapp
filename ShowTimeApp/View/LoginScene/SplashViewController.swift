//
//  SplashViewController.swift
//  ShowTimeApp
//
//  Created by mac on 4/26/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import FirebaseAuth

class SplashViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        
        
        //check if the user is logged in or not
        
        if Auth.auth().currentUser?.uid != nil {
            
            let mainTC = storyboard.instantiateViewController(withIdentifier: "MainTabController") as! UITabBarController
            
            appDelegate.window?.rootViewController = mainTC
            
            
        } else {
            
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            appDelegate.window?.rootViewController = loginVC
            
        }
    } //end func
    
    
    
}//end class
