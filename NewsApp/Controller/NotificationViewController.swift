//
//  NotificationViewController.swift
//  NewsApp
//
//  Created by macbook on 24/02/22.
//

import UIKit
import Kingfisher
import SafariServices

enum NotifItemGroup {
  case article
  case today
}

struct TodayListItem {
  var imageUrl: String
  var title: String
  var domainName: String
}

class NotificationViewController: UIViewController {
  @IBOutlet weak var textLogoLabel: UILabel!
  @IBOutlet weak var tableViewNotif: UITableView!
  
  var notifItemGroup: [NotifItemGroup] = [.article, .today]
  var articleItemContent: [ArticlesIndoNewsResponse] = []
  var todayItemContent: [TodayListItem] = []
  var todayItem: [ArticlesIndoNewsResponse] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableViewNotif.dataSource = self
    tableViewNotif.delegate = self
    tableViewNotif.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsCell")
    tableViewNotif.register(UINib(nibName: "TodayItemTableViewCell", bundle: nil), forCellReuseIdentifier: "todayItemCell")
    
    setup()
    
    loadArticle()
    loadTodayItem()
  }
  
  // MARK: - Helpers
  func loadArticle() {
    IndoNewsProvider.shared.loadListNews(pageSize: 3) { response in
      switch response {
      case .success(let articleNews):
        self.articleItemContent = articleNews
        self.tableViewNotif.reloadData()
      case .failure(let error):
        print("Error load article news: \(error.localizedDescription)")
      }
    }
  }
  
  func loadTodayItem() {
    todayItemContent = [
      TodayListItem(
        imageUrl: "icn_detik",
        title: "Detik News",
        domainName: "detik.com"),
      TodayListItem(
        imageUrl: "icn_tribun",
        title: "Tribun News",
        domainName: "tribunnews.com"),
      TodayListItem(
        imageUrl: "icn_cnn",
        title: "CNN Indonesia",
        domainName: "cnnindonesia.com")
    ]
  }
  
  func setup() {
    textLogoLabel.text = "Notification"
    textLogoLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
  }
}

// MARK: - extension UITableViewDataSource
extension NotificationViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return notifItemGroup.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let group = notifItemGroup[section]
    switch group {
    case .article:
      return articleItemContent.count
    case .today:
      return todayItemContent.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let group = notifItemGroup[indexPath.section]
    
    if group == .article {
      let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
      
      let articleNews = articleItemContent[indexPath.row]
      cell.titleLabel.text = articleNews.title
      cell.tagsLabel.text = "\(articleNews.publishedAt.string(format: "MMMM dd, yyyy h:mm a"))"
      
      let imageUrl = articleNews.urlToImage
      cell.loadingView.startAnimating()
      cell.thumbImageView.kf.setImage(with: URL(string: imageUrl)) { _ in
        cell.loadingView.stopAnimating()
      }
      
      cell.topConstraint.constant = indexPath.row == 0 ? 10 : 10
      cell.bottomConstraint.constant = indexPath.row == articleItemContent.count - 1 ? 20 : 10
      
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "todayItemCell", for: indexPath) as! TodayItemTableViewCell
      
      let todayContent = todayItemContent[indexPath.row]
      cell.todayImageView.image = UIImage(named: todayContent.imageUrl)
      cell.nameLabel.text = todayContent.title
      
      return cell
    }
  }
}

// MARK: - extension UITableViewDelegate
extension NotificationViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let group = notifItemGroup[indexPath.section]
    
    if group == .article {
      let listNews = articleItemContent[indexPath.row]
      if let url = URL(string: listNews.url) {
        let viewController = SFSafariViewController(url: url)
        present(viewController, animated: true, completion: nil)
      }
    } else {
      let detailStoryboard = UIStoryboard(name: "TodayDetail", bundle: nil)
      let detail = detailStoryboard.instantiateViewController(withIdentifier: "rootTodayDetail") as! TodayDetailViewController
      let listNews = todayItemContent[indexPath.row]
      
      detail.domainName = listNews.domainName
      
      self.navigationController?.pushViewController(detail, animated: true)
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return notifItemGroup[indexPath.section] == .article
  }
  
  func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return "Add to Reading List"
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let listNews = articleItemContent[indexPath.row]
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.viewContext
    
    NewsData.insert(news: listNews, context: context)
    appDelegate.saveContext()
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let group = notifItemGroup[section]
    if group == .article {
      let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
      
      let label = UILabel()
      label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height - 10)
      label.text = "Article For You"
      label.font = .boldSystemFont(ofSize: 18)
      label.textColor = .gray
      
      headerView.addSubview(label)
      
      return headerView
    } else {
      let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
      
      let label = UILabel()
      label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
      label.text = "Media Today"
      label.font = .boldSystemFont(ofSize: 18)
      label.textColor = .gray
      
      headerView.addSubview(label)
      
      return headerView
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    let group = notifItemGroup[section]
    switch group {
    case .article:
      return 50
    case .today:
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
