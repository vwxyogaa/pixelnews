//
//  TodayItemTableViewCell.swift
//  NewsApp
//
//  Created by macbook on 06/03/22.
//

import UIKit

class TodayItemTableViewCell: UITableViewCell {
  @IBOutlet weak var todayImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
