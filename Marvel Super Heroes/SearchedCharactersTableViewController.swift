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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: HeroDetailViewController.self)) as! HeroDetailViewController
        controller.character = characters[indexPath.row]
        
        self.present(controller, animated: true, completion: nil)
    }
}

extension SearchedCharactersTableViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadCharacters(startsWith: searchBar.text)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            characters?.removeAll()
            self.tableView.reloadData()
            return
        }
        
        if text == textToSearch {
            return
        }
        
        if delegate != nil {
            let loadedCharacters = delegate!.loadedCharacters()
            
            characters = loadedCharacters.filter { $0.name.lowercased().hasPrefix(text.lowercased()) }
            self.tableView.reloadData()
        }
        
        textToSearch = text
        offset = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if searchController.isActive == true && text == self.textToSearch && !self.loading {
                self.loadCharacters(startsWith: text)
            }
        }
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        favoriteCharacterIds = delegate?.getFavoriteCharacterIds()
    }
}
