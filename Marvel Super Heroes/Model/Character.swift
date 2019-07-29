//
//  Character.swift
//  Marvel Super Heroes
//
//  Created by Marcelo Bogdanovicz on 27/07/19.
//  Copyright © 2019 Marvel. All rights reserved.
//

import Foundation

struct Character: Codable {

    var id: Int
    var name: String
    var description: String
    var modified: String
    var thumbnail: Thumbnail
    var resourceURI: String
    var comics: CharacterAppearance
    var series: CharacterAppearance
    var stories: CharacterAppearance
    var events: CharacterAppearance
    var urls: [CharacterURL]
}

struct Thumbnail: Codable {
    
    enum CodingKeys: String, CodingKey {
        case path
        case thumbExtension = "extension"
    }
    
    var path: String
    var thumbExtension: String
}

struct CharacterAppearance: Codable {
    
    var available: Int
    var collectionURI: String
    var items: [Item]
    var returned: Int
}

struct Item: Codable {
    
    var resourceURI: String
    var name: String
    var type: String?
}

struct CharacterURL: Codable {
    
    var type: String
    var url: String
}
