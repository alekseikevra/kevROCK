//
//  MainColleCollectionViewCell.swift
//  kevROCK
//
//  Created by Aleksei Kevra on 03.06.2022.
//

import UIKit

class MainColleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    func setup(albumName: String, albumURL: String) {
        albumLabel.text = albumName
        if albumURL.isEmpty {
            albumImageView.image = nil
        } else {
            guard let url = URL(string: albumURL) else { return }
            albumImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
}

// MARK: - Configure
private extension MainColleCollectionViewCell {
    
    func setupUI() {
        albumImageView.clipsToBounds = true
        albumImageView.contentMode = .scaleAspectFill
        albumImageView.layer.cornerRadius = 10
    }
    
}
