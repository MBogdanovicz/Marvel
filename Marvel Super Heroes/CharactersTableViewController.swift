//
//  CharactersTableViewController.swift
//  Marvel Super Heroes
//
//  Created by Marcelo Bogdanovicz on 27/07/19.
//  Copyright © 2019 Marvel. All rights reserved.
//

import UIKit

class CharactersTableViewController: UITableViewController, CharacterTableViewCellDelegate {

    private var offset = 0
    let reuseIdentifier = "characterIdentifier"
    var characters: [Character]!
    var total = 0
    var loading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: String(describing: CharacterTableViewCell.self), bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    
    func loadCharacters(startsWith: String? = nil) {
        
        showLoadingCharacters()
        
        Service.characters(limit: 20, offset: offset, searchQuery: startsWith, success: { model in
            
            self.total = model.data.total
            self.offset += model.data.count
            
            self.didFindCharacters(model.data.results)
            self.hideLoadingCharacters()
        }) { error in
            self.hideLoadingCharacters()
            self.showError(error)
        }
    }
    
    private func didFindCharacters(_ characters: [Character]) {
        if self.characters == nil {
            self.characters = [Character]()
        }
        
        self.characters.append(contentsOf: characters)
        self.tableView.reloadData()
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
    
    func didAddToFavorite(_ character: Character) {
    }
    
    func didRemoveFavorite(_ character: Character) {
    }
    
    func getFavoriteIds() -> [Int] {
        fatalError("You must override: \(#function)")
    }
    
    func loadMore() {
        loadCharacters()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

extension CharactersTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CharacterTableViewCell
        let character = characters[indexPath.row]
        
        cell.delegate = self
        cell.config(character, favoriteList: getFavoriteIds())
        
        let count = characters.count
        
        if indexPath.row == count - 5 && count < total && !loading {
            
            loadMore()
        }
        
        return cell
    }
}
