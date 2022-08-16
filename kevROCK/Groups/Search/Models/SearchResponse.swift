//
//  SearchResponse.swift
//  kevROCK
//
//  Created by Aleksei Kevra on 25.05.2022.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    enum TrackType: String, Decodable {
        case artist
        case collection
    }
    let trackName: String?
    let collectionName: String?
    let artistName: String
    let artworkUrl60: String?
    let artworkUrl100: String?
    let wrapperType: TrackType?
}


