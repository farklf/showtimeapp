//
//  LoginViewController.swift
//  ShowTimeApp
//
//  Created by mac on 4/26/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var googleButton: GIDSignInButton!
  
    
   // let mysteryButton = FBSDKLoginButton()
    
    let imageArray = ["0","1","2"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.numberOfPages = imageArray.count
        scrollView.delegate = self
     
       
        
        setupGoogleButton()
        
        let btnFBLogin = FBSDKLoginButton()
        btnFBLogin.readPermissions = ["public_profile", "email", "user_friends"]
        btnFBLogin.delegate = self
        btnFBLogin.center = self.view.center
        let newCenter = CGPoint(x: 190, y: 600)
        btnFBLogin.center = newCenter
        self.view.addSubview(btnFBLogin)
        
   //     setupMysteryButton()
        
    }
    
 //   func mysteryButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
 //       print("did log out of facebook")
  //  }
    
  
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //make UI changes
        
        //set the scroll view width
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * (CGFloat(imageArray.count)), height: scrollView.frame.size.height)
        
        for number in 0..<imageArray.count {
            
            //center the frame on the current Image
            frame.origin.x = scrollView.frame.size.width * CGFloat(number)
            
            //set frame size to equal scroll view size
            frame.size = scrollView.frame.size
            
            //set image view frame
            let imageView = UIImageView(frame: frame)
            
            //set image view
            imageView.image = UIImage(named: imageArray[number])
            
            //set scrollsview subview as image
            self.scrollView.addSubview(imageView)
        }
    }
    

    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        guard pageControl.currentPage <= imageArray.count - 1 else {
            return
        }
        
        //increase current page
        pageControl.currentPage += 1
        
        //find the x by using the current page times the width of the scroll view
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        
        //offset our scroll view by x
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        
        
        //layout subview  if needed
        scrollView.layoutIfNeeded()
        
    }
    
    @IBAction func prevButtonTapped(_ sender: UIButton) {
        
        guard pageControl.currentPage >= 0 else {
            return
        }
        
        //decrease current page
        pageControl.currentPage -= 1
        
        //find the x
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        
        //offset our scroll view by x
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        
        
        //layout subview  if needed
        scrollView.layoutIfNeeded()
        
    }
    
    @IBAction func googleButtonTapped(_ sender: UIButton) {
       GIDSignIn.sharedInstance()?.signIn()
        
    }
    
    
    
    //MARK: Sign In Function
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if let err = error {
            print("Error Signing in Google: \(err.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let err = error {
                print("Couldn't Authenticate User to Firebase: \(err.localizedDescription)")
                return
            }
            
            if let auth = authResult {
                
                print("Successfully Authenticated User to Firebase: \(auth.user.uid)")
                
                self.goToHome()
            }
            
        }
        
    }
    
    
    
    
    //MARK: Button Setups
    
    func setupGoogleButton() {
        
        googleButton.layer.cornerRadius = googleButton.layer.frame.size.height / 2
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
    
   
 
    //creating the Facebook sign in button
    fileprivate func configureFacebookSignInButton() {
        let facebookSignInButton = FBSDKLoginButton()
        facebookSignInButton.frame = CGRect(x: 120, y: 200 + 100, width: view.frame.width - 240, height: 40)
        view.addSubview(facebookSignInButton)
        facebookSignInButton.delegate = self as! FBSDKLoginButtonDelegate
    }
    //FBSDKLoginButton delegate methods
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error == nil {
            print("User just logged in via Facebook")
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
       //     Auth.auth().signIn(with: credential, completion: { (user, error) in
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
                if (error != nil) {
                    print("Facebook authentication failed \(error?.localizedDescription) ")
                } else {
                    print("Facebook authentication succeed")
                    self.goToHome()
                }
            })
        } else {
            print("An error occured the user couldn't log in")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User just logged out from his Facebook account")
    }
 
}
 

//MARK: ScrollView Delegate
extension LoginViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //calculate the offset of the scroll view to get the current page
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        //set content page number to the page conrols current page
        pageControl.currentPage = Int(pageNumber)
    }
}
