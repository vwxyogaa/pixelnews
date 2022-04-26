//
//  TodayDetailViewController.swift
//  NewsApp
//
//  Created by macbook on 06/03/22.
//

import UIKit
import SafariServices

class TodayDetailViewController: UIViewController {
  @IBOutlet weak var tableViewDetail: UITableView!
  
  var domainName = ""
  var detailList: [ArticlesIndoNewsResponse] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableViewDetail.dataSource = self
    tableViewDetail.delegate = self
    tableViewDetail.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsCell")
    
    loadDetailList()
  }
  
  // MARK: - Helpers
  func loadDetailList() {
    IndoNewsProvider.shared.loadDetailListNews(domains: domainName) { response in
      switch response {
      case .success(let listNews):
        self.detailList = listNews
        self.tableViewDetail.reloadData()
      case .failure(let error):
        print("Error load list news: \(error.localizedDescription)")
      }
    }
  }
}

// MARK: - extension UITableViewDataSource
extension TodayDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return detailList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
    
    let listNews = detailList[indexPath.row]
    cell.titleLabel.text = listNews.title
    cell.tagsLabel.text = "\(listNews.publishedAt.string(format: "MMMM dd, yyyy h:mm a"))"
    
    let imageUrl = listNews.urlToImage
    cell.loadingView.startAnimating()
    cell.thumbImageView.kf.setImage(with: URL(string: imageUrl)) { _ in
      cell.loadingView.stopAnimating()
    }
    
    cell.topConstraint.constant = indexPath.row == 0 ? 20 : 10
    cell.bottomConstraint.constant = indexPath.row == detailList.count - 1 ? 20 : 10
    
    return cell
  }
}

// MARK: - extension UITableViewDelegate
extension TodayDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let listNews = detailList[indexPath.row]
    if let url = URL(string: listNews.url) {
      let viewController = SFSafariViewController(url: url)
      present(viewController, animated: true, completion: nil)
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return "Add to Reading List"
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let listNews = detailList[indexPath.row]
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.viewContext
    
    NewsData.insert(news: listNews, context: context)
    appDelegate.saveContext()
  }
}
