//
//  MarvelModel.swift
//  Marvel Super Heroes
//
//  Created by Marcelo Bogdanovicz on 27/07/19.
//  Copyright © 2019 Marvel. All rights reserved.
//

import Foundation

struct MarvelModel: Codable {

    var copyright: String
    var attributionText: String
    var data: MarvelData
}

struct MarvelData: Codable {
    
    var offset: Int
    var limit: Int
    var total: Int
    var count: Int
    var results: [Character]
}
