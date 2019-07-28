//
//  CharacterTableViewCell.swift
//  Marvel Super Heroes
//
//  Created by Marcelo Bogdanovicz on 27/07/19.
//  Copyright © 2019 Marvel. All rights reserved.
//

import UIKit

protocol CharacterTableViewCellDelegate: AnyObject {
    
    func didAddToFavorite(_ character: Character)
    func didRemoveFavorite(_ character: Character)
}

class CharacterTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var favorite: UIButton!
    private var character: Character!
    weak var delegate: CharacterTableViewCellDelegate?
    
    func config(_ character: Character, favoriteList: [Int]) {
        
        self.character = character
        let thumbURL = "\(character.thumbnail.path)/standard_medium.\(character.thumbnail.thumbExtension)"
        thumbnail.downloadImage(from: thumbURL)
        
        name.text = character.name
        
        if favoriteList.contains(character.id) {
            favorite.isSelected = true
        } else {
            favorite.isSelected = false
        }
    }
    
    @IBAction func didPressFavorite(_ sender: Any) {
        favorite.isSelected = !favorite.isSelected
        
        if favorite.isSelected {
            Database.addToFavorite(character)
            delegate?.didAddToFavorite(character)
        } else {
            Database.removeFromFavorite(character)
            delegate?.didRemoveFavorite(character)
        }
    }
}
