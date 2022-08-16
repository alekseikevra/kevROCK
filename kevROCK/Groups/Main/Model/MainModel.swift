//
//  MainModel.swift
//  kevROCK
//
//  Created by Aleksei Kevra on 03.06.2022.
//

import UIKit

struct Albums {
    
    var albumLabel: String
    var albumImage: UIImage
}

class MainLaunch {
    
    var search: SearchViewController = SearchViewController()
    var searchResponse: SearchResponse? = nil
    
    
    var albums = [Albums]()
    
    init() {
        setup()
    }
    
    func setup() {
        let album1 = Albums(albumLabel: "Album 1", albumImage: UIImage(named: "album1")!)
        let album2 = Albums(albumLabel: "Album 2", albumImage: UIImage(named: "album2")!)
        let album3 = Albums(albumLabel: "Album 3", albumImage: UIImage(named: "album3")!)
        let album4 = Albums(albumLabel: "Album 4", albumImage: UIImage(named: "album1")!)
        let album5 = Albums(albumLabel: "Album 5", albumImage: UIImage(named: "album2")!)
        let album6 = Albums(albumLabel: "Album 6", albumImage: UIImage(named: "album3")!)
        self.albums = [album1, album2, album3, album4, album5, album6]
    }
}


