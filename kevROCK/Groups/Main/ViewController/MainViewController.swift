//
//  MainViewController.swift
//  kevROCK
//
//  Created by Aleksei Kevra on 12.05.2022.
//

import UIKit
import FirebaseAuth
import Firebase


class MainViewController: UIViewController {

    // - UI
    @IBOutlet weak var collectionView: UICollectionView!
    
    // - Variables
    let networkService = NetworkService()
    var results: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
}

// MARK: - CollectionView DataSource, Delegate
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainColleCollectionViewCell", for: indexPath) as! MainColleCollectionViewCell
        let track = results[indexPath.row]
        cell.setup(albumName: track.collectionName ?? "Error", albumURL: track.artworkUrl100 ?? "")
        return cell
    }
    
}

// MARK: - Configure
private extension MainViewController {
    
    func configure() {
        configureCollectionView()
        getData()
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func getData() {
        let urlString = "https://itunes.apple.com/lookup?id=111051&entity=album"
        networkService.request(urlString: urlString) { [weak self] result in
            switch result {
            case .success(let searchResponse):
                self?.results = searchResponse.results.filter({$0.wrapperType == .collection})
                self?.collectionView.reloadData()
            case .failure(let error):
                print(error, "error")
            }
        }
    }
    
}

