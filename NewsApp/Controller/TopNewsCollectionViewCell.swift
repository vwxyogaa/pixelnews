//
//  TopNewsCollectionViewCell.swift
//  NewsApp
//
//  Created by macbook on 24/02/22.
//

import UIKit

protocol TopNewsCollectionViewCellDelegate: NSObjectProtocol {
  func TopNewsCollectionViewCellBookmarkButtonTapped(_ cell: TopNewsCollectionViewCell)
}

class TopNewsCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var tagsLabel: UILabel!
  @IBOutlet weak var loadingView: UIActivityIndicatorView!
  @IBOutlet weak var bookmarkButton: UIButton!
  
  weak var delegate: TopNewsCollectionViewCellDelegate?
  
  @IBAction func bookmarkButtonTapped(_ sender: Any) {
    delegate?.TopNewsCollectionViewCellBookmarkButtonTapped(self)
  }
}
