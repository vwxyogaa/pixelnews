//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by macbook on 24/02/22.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var tagsLabel: UILabel!
  @IBOutlet weak var thumbImageView: UIImageView!
  @IBOutlet weak var loadingView: UIActivityIndicatorView!
  
  @IBOutlet weak var topConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
