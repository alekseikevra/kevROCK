//
//  SearchViewController.swift
//  kevROCK
//
//  Created by Aleksei Kevra on 24.05.2022.
//

import UIKit
import SDWebImage

class SearchViewController: UIViewController {
    
    // - UI
    @IBOutlet weak var resultTableView: UITableView!
    
    let networkService = NetworkService()
    var searchResponse: SearchResponse? = nil
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
}

// MARK: - TableView dataSource, delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTableView.dequeueReusableCell(withIdentifier: "InfoTrackTableViewCell", for: indexPath) as! InfoTrackTableViewCell
        let track = searchResponse?.results[indexPath.row]
        cell.textLabel?.text = track?.trackName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

// MARK: - SearchBar delegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let urlString = "https://itunes.apple.com/search?term=\(searchText)&limit=50"
        self.networkService.request(urlString: urlString) { [weak self] result in
            switch result {
            case .success(let searchResponse):
                self?.searchResponse = searchResponse
                self?.resultTableView.reloadData()
            case .failure(let error):
                print(error, "error")
            }
        }
    }
}

// MARK: - Configure
private extension SearchViewController {
    
    func configure() {
        setupTableView()
        setupSearchBar()
        configureSearchBar()
    }
    
    func setupTableView() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    func configureSearchBar() {
        searchController.searchBar.searchBarStyle = .minimal
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
}
