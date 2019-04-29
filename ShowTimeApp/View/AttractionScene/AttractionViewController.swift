//
//  ViewController.swift
//  ShowTimeApp
//
//  Created by mac on 4/23/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class AttractionViewController: UIViewController {
    
    @IBOutlet weak var attractionTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel = ViewModel()
    let fireModel = FireViewModel.shared
    let favoriteImage = UIImage(named: "greystar")!.withRenderingMode(.alwaysTemplate)
    var updateCollection = false
    
    var shouldLoadPlaceholder: Bool {
        return viewModel.attrs.isEmpty ? true : false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSearch()
        createObserver()
        setupViewModel()
        editAttrTable()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fireModel.getFire()
    }
    
  
    
    //MARK: Create Observer
    func createObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAttrFire), name: Notification.Name.fireNotification, object: nil)
    }
    
    @objc func updateAttrFire() {
        
        DispatchQueue.main.async {
            self.attractionTableView.reloadData()
        }
        
    }
    
    
    //MARK: ViewModel Setup
    
    func setupViewModel() {
        
        viewModel.get(with: nil)
        viewModel.delegate = self
        
    }
    
    //MARK: Favorite Functionality
    @objc func favoriteTapped(sender: UIButton) {
        
        //We must get the correct attraction
        let attr = isFiltering() ? viewModel.filteredAttrs[sender.tag] : viewModel.attrs[sender.tag]
        let attrID = attr.id
        let state = sender.tintColor == .gold ? true : false
        
        sender.isSelected = !state
        
        //Change color of star based on the buttons active status
        if sender.isSelected {
            
            //save the attraction to Firebase
            FireService.shared.save(attr)
            sender.tintColor = .gold
            fireModel.favoritesID.insert(attrID)
            
        } else {
            
            //remove the attraction from firebase
            FireService.shared.remove(attr)
            sender.tintColor = .lightGray
            fireModel.favoritesID.remove(attrID)
            
        }
    }
    
    
    //MARK: Search Functionality
    
    
    func createSearch() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    func filterAttrs(with search: String) {
        
        
        viewModel.filteredAttrs = viewModel.attrs.filter({$0.name.lowercased().contains(search.lowercased()) || $0.classifications.first!.genre.name.lowercased().contains(search.lowercased())})
        updateCollection = true
//        for attr in viewModel.attrs {
//
//            if attr.name.lowercased().contains(search.lowercased()) {
//                viewModel.filteredAttrs.append(attr)
//            }
//        }
        
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    
    
    //MARK: Edit AttrTable
    func editAttrTable() {
        attractionTableView.tableFooterView = UIView(frame: .zero)
        attractionTableView.backgroundColor = .white
    }
    


} //end class

//MARK: Table View

extension AttractionViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return section == 0 ? 1 : viewModel.filteredAttrs.count
        }
        
        if shouldLoadPlaceholder {
            attractionTableView.backgroundView = AttractionPlaceholder.instanceFromNib()
        }
        
        let firstSectionCount = shouldLoadPlaceholder ? 0 : 1
        
        return section == 0 ? firstSectionCount : viewModel.attrs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AttractionTableCell.identifiers[indexPath.section], for: indexPath) as! AttractionTableCell
        
        switch indexPath.section {
        case 0:
            
            if updateCollection {
                cell.attractionCollectionView.reloadData()
                updateCollection = false
            }
            
        default:
            
            let attr = isFiltering() ? viewModel.filteredAttrs[indexPath.row] : viewModel.attrs[indexPath.row]
            
            //MARK: Favorite Button Setup
            cell.attractionFavoriteButton.addTarget(self, action: #selector(favoriteTapped(sender:)), for: .touchUpInside)
            cell.attractionFavoriteButton.tag = indexPath.row
            cell.attractionFavoriteButton.setImage(favoriteImage, for: .normal)
            cell.attractionFavoriteButton.tintColor = fireModel.favoritesID.contains(attr.id) ? .gold : .lightGray
            
            
            cell.configureTable(with: attr)
            
        }
        
        return cell
    }
    

    
} //end extension


extension AttractionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 120 : 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Web", bundle: Bundle.main)
        let webVC = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        
        let currentAttr = isFiltering() ? viewModel.filteredAttrs[indexPath.row] : viewModel.attrs[indexPath.row]
        webVC.attr = currentAttr
        
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    
} //end extension

//MARK: Collection View

extension AttractionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltering() ? viewModel.filteredAttrs.count : viewModel.attrs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttractionCollectionCell.identifier, for: indexPath) as! AttractionCollectionCell
        
        let attr = isFiltering() ? viewModel.filteredAttrs[indexPath.row] : viewModel.attrs[indexPath.row]
        cell.configureCollection(with: attr)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let index = IndexPath(row: indexPath.row, section: 1)
        attractionTableView.scrollToRow(at: index, at: .top, animated: true)
    }
} //end extension


extension AttractionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 126, height: 108)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
} //end extension


//MARK: Search Results Updater

extension AttractionViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let search = searchController.searchBar.text else {
            return
        }
        
        filterAttrs(with: search)
    }
    
} //end extension

//MARK: Attractions Delegate

extension AttractionViewController: AttrDelegate {
    
    func updateAttrs() {
        
        DispatchQueue.main.async {
            self.updateCollection = true
            self.attractionTableView.backgroundView = nil
            self.attractionTableView.reloadData()
            print("Reloaded Attraction Table")
        }
    } //end func
    
} //end extension
