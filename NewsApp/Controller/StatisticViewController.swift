//
//  StatisticViewController.swift
//  NewsApp
//
//  Created by macbook on 24/02/22.
//

import UIKit
import Alamofire
import SafariServices

enum StatisticItemGroup {
  case yourStats
  case readlingList
}

class StatisticViewController: UIViewController {
  @IBOutlet weak var textLogoLabel: UILabel!
  @IBOutlet weak var tableViewStatistic: UITableView!
  
  var statisticItemGroup: [StatisticItemGroup] = [.yourStats, .readlingList]
  var yourStatsContent: [Any] = [1]
  var readingListContent: [NewsData] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    tableViewStatistic.dataSource = self
    tableViewStatistic.delegate = self
    tableViewStatistic.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsCell")
    
    NotificationCenter.default.addObserver(self, selector: #selector(reloadNewsDatabase), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
    
    loadNewsDatabase()
  }
  
  // MARK: - Helpers
  @objc func reloadNewsDatabase() {
    loadNewsDatabase()
    tableViewStatistic.reloadData()
  }
  
  func removeListNews(_ news: NewsData) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.viewContext
    
    context.delete(news)
    appDelegate.saveContext()
  }
  
  func loadNewsDatabase() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.viewContext
    readingListContent = NewsData.select(context: context)
  }
  
  func setup() {
    textLogoLabel.text = "Summary Stats"
    textLogoLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
  }
}

// MARK: - extension UITableViewDataSource
extension StatisticViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return statisticItemGroup.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let group = statisticItemGroup[section]
    switch group {
    case .yourStats:
      return yourStatsContent.count
    case .readlingList:
      return readingListContent.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let group = statisticItemGroup[indexPath.section]
    
    if group == .yourStats {
      let cell = tableView.dequeueReusableCell(withIdentifier: "yourStatsCell", for: indexPath) as! YourStatsTableViewCell
      
      cell.containerYourStats.layer.cornerRadius = 8
      cell.containerYourStats.layer.masksToBounds = true
      cell.containerYourStats.layer.borderWidth = 1
      cell.containerYourStats.layer.borderColor = UIColor.darkGray.cgColor
      cell.containerYourStats.layer.backgroundColor = UIColor.clear.cgColor
      
      cell.todayDailyLabel.text = "Today Daily"
      cell.readAmountLabel.text = "0"
      cell.readLabel.text = "Read"
      cell.favoriteAmountLabel.text = "0"
      cell.favoriteLabel.text = "Favorite"
      cell.savedAmountLabel.text = "\(readingListContent.count)"
      cell.savedLabel.text = "Saved"
      
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
      
      let news = readingListContent[indexPath.row]
      cell.titleLabel.text = news.title
      
      let date = news.publishedAt
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMMM dd, yyyy h:mm a"
      let dateFormattedString = dateFormatter.string(from: date)
      cell.tagsLabel.text = dateFormattedString
      
      let urlString = news.urlToImage
      cell.thumbImageView.kf.setImage(with: URL(string: urlString))
      
      cell.topConstraint.constant = indexPath.row == 0 ? 5 : 10
      cell.bottomConstraint.constant = indexPath.row == readingListContent.count - 1 ? 10 : 5
      
      return cell
    }
  }
}

// MARK: - extension UITableViewDelegate
extension StatisticViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let group = statisticItemGroup[indexPath.section]
    
    if group == .readlingList {
      let listNews = readingListContent[indexPath.row]
      if let url = URL(string: listNews.url) {
        let viewController = SFSafariViewController(url: url)
        present(viewController, animated: true, completion: nil)
      }
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return statisticItemGroup[indexPath.section] == .readlingList
  }
  
  func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return "Remove from reading list"
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let alert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
      let news = self.readingListContent.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
      
      self.removeListNews(news)
    }))
    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
    
    present(alert, animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let group = statisticItemGroup[section]
    
    if group == .yourStats {
      let headerView = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
      
      let label = UILabel()
      label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
      label.text = "Your Stats"
      label.font = UIFont.boldSystemFont(ofSize: 18)
      label.textColor = .gray
      
      headerView.addSubview(label)
      
      return headerView
    } else {
      let headerView = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
      
      let label = UILabel()
      label.frame = CGRect(x: 20, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
      label.text = "Reading List"
      label.font = UIFont.systemFont(ofSize: 18)
      label.textColor = .gray
      
      headerView.addSubview(label)
      
      return headerView
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    let group = statisticItemGroup[section]
    switch group {
    case .yourStats:
      return 50
    case .readlingList:
      return 50
    }
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return nil
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return CGFloat.leastNormalMagnitude
  }
}
