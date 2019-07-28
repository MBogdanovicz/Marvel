//
//  HomeTableViewController.swift
//  Marvel Super Heroes
//
//  Created by Marcelo Bogdanovicz on 28/07/19.
//  Copyright © 2019 Marvel. All rights reserved.
//

import UIKit

class HomeTableViewController: CharactersTableViewController, SearchedCharactersTableViewControllerDelegate {

    private var searchResultsController: SearchedCharactersTableViewController!
    private var favoriteCharacterIds = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteCharacterIds = Database.loadFavorite()
        loadCharacters()
        setupSearch()
    }
    
    private func setupSearch() {
        searchResultsController = SearchedCharactersTableViewController(style: .plain)
        searchResultsController.tableView.dataSource = searchResultsController
        searchResultsController.tableView.delegate = searchResultsController
        searchResultsController.delegate = self
        
        let searchController = UISearchController(searchResultsController: searchResultsController)
        self.navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchResultsUpdater = searchResultsController
        searchController.delegate = searchResultsController
        searchController.searchBar.delegate = searchResultsController
        
        self.definesPresentationContext = true
    }
    
    override func getFavoriteIds() -> [Int] {
        return favoriteCharacterIds
    }
    
    // Mark: - SearchedCharactersTableViewControllerDelegate
    
    override func didAddToFavorite(_ character: Character) {
        favoriteCharacterIds.append(character.id)
    }
    
    override func didRemoveFavorite(_ character: Character) {
        favoriteCharacterIds.removeAll { $0 == character.id }
    }
    
    func loadedCharacters() -> [Character] {
        return characters
    }
    
    func getFavoriteCharacterIds() -> [Int] {
        return favoriteCharacterIds
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "infoSegue", sender: characters[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as? HeroDetailViewController
        viewController?.character = sender as? Character
    }
}
