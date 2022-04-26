//
//  YourStatsTableViewCell.swift
//  NewsApp
//
//  Created by macbook on 03/03/22.
//

import UIKit

class YourStatsTableViewCell: UITableViewCell {
  @IBOutlet weak var containerYourStats: UIView!
  @IBOutlet weak var todayDailyLabel: UILabel!
  @IBOutlet weak var readAmountLabel: UILabel!
  @IBOutlet weak var readLabel: UILabel!
  @IBOutlet weak var favoriteAmountLabel: UILabel!
  @IBOutlet weak var favoriteLabel: UILabel!
  @IBOutlet weak var savedAmountLabel: UILabel!
  @IBOutlet weak var savedLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
