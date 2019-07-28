//
//  SearchedCharactersTableViewController.swift
//  Marvel Super Heroes
//
//  Created by Marcelo Bogdanovicz on 28/07/19.
//  Copyright © 2019 Marvel. All rights reserved.
//

import UIKit

protocol SearchedCharactersTableViewControllerDelegate: AnyObject {
    
    func loadedCharacters() -> [Character]
    func getFavoriteCharacterIds() -> [Int]
    func didAddToFavorite(_ character: Character)
    func didRemoveFavorite(_ character: Character)
}

class SearchedCharactersTableViewController: CharactersTableViewController {

    private var textToSearch = ""
    private var favoriteCharacterIds: [Int]?
    weak var delegate: SearchedCharactersTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadMore() {
        loadCharacters(startsWith: textToSearch)
    }
    
    override func tryAgain() {
        loadCharacters(startsWith: textToSearch)
    }
    
    override func getFavoriteIds() -> [Int] {
        return delegate?.getFavoriteCharacterIds() ?? [Int]()
    }
    
    override func didAddToFavorite(_ character: Character) {
        delegate?.didAddToFavorite(character)
    }
    
    override func didRemoveFavorite(_ character: Character) {
        delegate?.didRemoveFavorite(character)
    }
}

extension SearchedCharactersTableViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            characters?.removeAll()
            self.tableView.reloadData()
            return
        }
        
        if delegate != nil {
            let loadedCharacters = delegate!.loadedCharacters()
            
            characters = loadedCharacters.filter { $0.name.lowercased().hasPrefix(text.lowercased()) }
            self.tableView.reloadData()
        }
        
        textToSearch = text
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.validateSearch(text: text)
        }
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        favoriteCharacterIds = delegate?.getFavoriteCharacterIds()
    }
    
    private func validateSearch(text: String) {
        
        if text == textToSearch {
            loadCharacters(startsWith: text)
        }
    }
}
