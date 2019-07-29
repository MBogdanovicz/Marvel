//
//  Marvel_Super_HeroesTests.swift
//  Marvel Super HeroesTests
//
//  Created by Marcelo Bogdanovicz on 27/07/19.
//  Copyright © 2019 Marvel. All rights reserved.
//

import XCTest
@testable import Marvel_Super_Heroes

class Marvel_Super_HeroesTests: XCTestCase {

    var appearance: CharacterAppearance!
    var character: Character!
    
    override func setUp() {
        super.setUp()
        appearance = CharacterAppearance(available: 0, collectionURI: "", items: [Item](), returned: 0)
        character = Character(id: -99, name: "", description: "", modified: "", thumbnail: Thumbnail(path: "", thumbExtension: ""), resourceURI: "", comics: appearance, series: appearance, stories: appearance, events: appearance, urls: [CharacterURL]())
    }
    
    func fileURL(filename: String) -> URL? {
        let bundle = Bundle(for: type(of: self))
        return bundle.url(forResource: filename, withExtension: "json")
    }
    
    func testUserMapping() throws {
        guard let url = fileURL(filename: "Characters") else {
            XCTFail("Missing file: Characters.json")
            return
        }
        
        let jsonData = try Data(contentsOf: url)
        let model = try JSONDecoder().decode(MarvelModel.self, from: jsonData)
        
        XCTAssertEqual(model.data.results[0].id, 1011334)
        XCTAssertEqual(model.data.results[1].name, "A-Bomb (HAS)")
    }
    
    func testAddFavorite() {
        
        Database.addToFavorite(character)
        let favorites = Database.loadFavorite()
        XCTAssertTrue(favorites.contains(character.id))
    }
    
    func testRemoveFavorite() {
        Database.removeFromFavorite(character)
        
        let favorites = Database.loadFavorite()
        XCTAssertFalse(favorites.contains(character.id))
    }
}
