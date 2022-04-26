//
//  CovidNewsTableViewCell.swift
//  NewsApp
//
//  Created by macbook on 24/02/22.
//

import UIKit

class CovidNewsTableViewCell: UITableViewCell {
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var topConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setup() {
    containerView.layer.cornerRadius = 8
    containerView.layer.masksToBounds = true
    containerView.layer.borderWidth = 1
    containerView.layer.borderColor = UIColor(hex: "707070").cgColor
  }
}
