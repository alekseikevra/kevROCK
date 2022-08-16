//
//  InfoTrackTableViewCell.swift
//  kevROCK
//
//  Created by Aleksei Kevra on 30.05.2022.
//

import UIKit

class InfoTrackTableViewCell: UITableViewCell {

    
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    
    var likeAction: (() -> Void)?
    private var isLiked: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setup(track: Track, isLiked: Bool) {
        self.isLiked = isLiked
        artistNameLabel.text = track.artistName
        trackLabel.text = track.trackName
        if let trackUrl = track.artworkUrl60 {
            let url = URL(string: trackUrl)
            albumImageView.sd_setImage(with: url, completed: nil)
        } else {
            albumImageView.image = nil
        }
        
        if isLiked {
            likeImageView.image = UIImage(named: "Like")
        } else {
            likeImageView.image = UIImage(named: "Vector off")
        }
    }
    
    @objc func likeImageTapped(_ gesture: UITapGestureRecognizer) {
        isLiked = !isLiked
        if isLiked {
            likeImageView.image = UIImage(named: "Like")            
        } else {
            likeImageView.image = UIImage(named: "Vector off")
        }
    }

}

// MARK: - Configure
private extension InfoTrackTableViewCell {
    
    func setupUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeImageTapped))
        likeImageView.addGestureRecognizer(tap)
        albumImageView.clipsToBounds = true
        albumImageView.contentMode = .scaleAspectFill
        albumImageView.layer.cornerRadius = 10
    }
    
}
