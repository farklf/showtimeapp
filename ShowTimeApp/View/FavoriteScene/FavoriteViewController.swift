//
//  FavoriteViewController.swift
//  ShowTimeApp
//
//  Created by mac on 4/24/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import FirebaseAuth

class FavoriteViewController: UIViewController {

    @IBOutlet weak var favoriteTableView: UITableView!
    
    let fireModel = FireViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createFavoriteObserver()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupFireModel()
        editFireTable()
    }
    
    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        
        do {
            
            try firebaseAuth.signOut()
            
        } catch {
            
            print ("Error signing out: \(error.localizedDescription)")
        }
        
        goToLogin()
    }
    
    
    
    //MARK: Create Observer
    
    func createFavoriteObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavFire), name: Notification.Name.fireNotification, object: nil)
    }
    
    @objc func updateFavFire() {
        
        DispatchQueue.main.async {
            self.favoriteTableView.reloadData()
        }
    }
    
    
    
    //MARK: Setup FireModel
    func setupFireModel() {

        fireModel.getFire()
    }
    
    //MARK: Edit FireTable
    func editFireTable() {
        favoriteTableView.tableFooterView = UIView(frame: .zero)
        favoriteTableView.backgroundColor = .white
        title = "Favorites"
    }


} //end class

//MARK: Table View

extension FavoriteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fireModel.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableCell.identifier, for: indexPath) as! FavoriteTableCell
        
        
        let attr = fireModel.favorites[indexPath.row]
        cell.configureFavorite(with: attr)
        
        
        return cell
    }
}


extension FavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            //Get the correct Atttraction
            let attr = fireModel.favorites[indexPath.row]
            //Get the ID
            let attrID = attr.id
            
            //Remove favorite ID for fireModel
            fireModel.favoritesID.remove(attrID)
            
            //Remove attr from fireModel
            fireModel.favorites.remove(at: indexPath.row)
            
            // Remove attr from firebase
            FireService.shared.remove(attr)
            
            //Reload Table View
            favoriteTableView.reloadData()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Web", bundle: Bundle.main)
        let webVC = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        
        let currentAttr = fireModel.favorites[indexPath.row]
        webVC.attr = currentAttr
        
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
}
