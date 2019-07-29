//
//  CharactersTableViewController.swift
//  Marvel Super Heroes
//
//  Created by Marcelo Bogdanovicz on 27/07/19.
//  Copyright © 2019 Marvel. All rights reserved.
//

import UIKit

class CharactersTableViewController: UITableViewController {

    private let reuseIdentifier = "characterIdentifier"
    private var searchController: UISearchController!
    private var favoriteCharacterIds: [Int]!
    private var characters: [Character]!
    private var searchedCharacters: [Character]?
    private var offset = 0
    private var total = 0
    private var loading = false
    private var textToSearch = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        favoriteCharacterIds = Database.loadFavorite()
        loadCharacters()
        setupSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func loadCharacters(startsWith: String? = nil) {
        
        textToSearch = ""
        showLoadingCharacters()
        
        Service.characters(limit: 20, offset: isSearching() ? 0 : offset, searchQuery: startsWith, success: { model in
            
            self.didFindCharacters(model.data.results)
            if !self.isSearching() {
                self.total = model.data.total
                self.offset += model.data.count
            }
            
            self.hideLoadingCharacters()
        }) { error in
            self.hideLoadingCharacters()
            self.showError(error)
        }
    }
    
    private func setupSearch() {
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
        
        self.definesPresentationContext = true
    }
    
    private func didFindCharacters(_ characters: [Character]) {
        if isSearching() {
            searchedCharacters = characters
        } else {
            if self.characters == nil || offset == 0 {
                self.characters = [Character]()
            }
            
            self.characters.append(contentsOf: characters)
        }
        
        tableView.reloadData()
    }
    
    override func tryAgain() {
        loadCharacters()
    }
    
    private func showLoadingCharacters() {
        loading = true
        if offset == 0 {
            showLoading()
        } else {
            showFooterLoading()
        }
    }
    
    private func hideLoadingCharacters() {
        self.loading = false
        hideLoading()
        hideFooterLoading()
    }
}

extension CharactersTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching() {
            return searchedCharacters?.count ?? 0
        } else {
            return characters?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CharacterTableViewCell
        let character: Character
        
        if isSearching() {
            character = searchedCharacters![indexPath.row]
        } else {
            character = characters[indexPath.row]
        }
        
        cell.delegate = self
        cell.config(character, favoriteList: favoriteCharacterIds)
        
        let count = characters.count
        
        if indexPath.row == count - 5 && count < total && !loading && !isSearching() {
            
            loadCharacters()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character: Character
        
        if isSearching() {
            character = searchedCharacters![indexPath.row]
        } else {
            character = characters[indexPath.row]
        }
        performSegue(withIdentifier: "infoSegue", sender: character)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as? HeroDetailViewController
        viewController?.character = sender as? Character
        viewController?.favoriteCharacterIds = favoriteCharacterIds
        viewController?.delegate = self
    }
}

extension CharactersTableViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadCharacters(startsWith: searchBar.text)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty, text != textToSearch else {
            return
        }

        searchedCharacters = characters.filter { $0.name.lowercased().hasPrefix(text.lowercased()) }
        self.tableView.reloadData()
        
        textToSearch = text
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if searchController.isActive == true && text == self.textToSearch && !self.loading {
                self.loadCharacters(startsWith: text)
            }
        }
    }
    
    func isSearching() -> Bool {
        return searchController?.isActive ?? false && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        tableView.reloadData()
    }
}

extension CharactersTableViewController: CharacterTableViewCellDelegate, HeroDetailViewControllerDelegate {
    
    func didAddToFavorite(_ character: Character) {
        favoriteCharacterIds.append(character.id)
    }
    
    func didRemoveFavorite(_ character: Character) {
        favoriteCharacterIds.removeAll { $0 == character.id }
    }
}

extension CharactersTableViewController: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            return FadePushAnimator()
        case .pop:
            return FadePopAnimator()
        default:
            return nil
        }
    }
}
