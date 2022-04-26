//
//  HeadlineViewController.swift
//  NewsApp
//
//  Created by macbook on 24/02/22.
//

import UIKit
import Kingfisher
import SafariServices

enum HeadlineItemGroup {
  case search
  case newsItem
}

class HeadlineViewController: UIViewController {
  @IBOutlet weak var tableViewHeadlines: UITableView!
  @IBOutlet weak var textLogoLabel: UILabel!
  
  lazy var activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.hidesWhenStopped = true
    if #available(iOS 13.0, *) {
      activityIndicator.style = .large
    }
    return activityIndicator
  }()
  
  var headlineItemGroup: [HeadlineItemGroup] = [.search, .newsItem]
  
  var searchContent: [Any] = [1]
  var newsItemContent: [ArticlesIndoNewsResponse] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableViewHeadlines.dataSource = self
    tableViewHeadlines.delegate = self
    tableViewHeadlines.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsCell")
    
    setup()
    setupActivityIndicator()
    loadListNews()
  }
  
  // MARK: - Helpers
  func loadListNews() {
    activityIndicator.startAnimating()
    IndoNewsProvider.shared.loadListNews(pageSize: 5) { response in
      switch response {
      case .success(let listNews):
        self.newsItemContent = listNews
        self.activityIndicator.stopAnimating()
        self.tableViewHeadlines.reloadData()
      case .failure(let error):
        print("Error load list news: \(error.localizedDescription)")
      }
    }
  }
  
  func search(_ query: String) {
    IndoNewsProvider.shared.searchNews(query: query) { result in
      switch result {
      case .success(let data):
        self.newsItemContent = data
        self.tableViewHeadlines.reloadData()
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  func setup() {
    textLogoLabel.text = "Headlines"
    textLogoLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
  }
  
  private func setupActivityIndicator() {
    view.addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
}

// MARK: - extension UITableViewDataSource
extension HeadlineViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return headlineItemGroup.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let group = headlineItemGroup[section]
    switch group {
    case .search:
      return searchContent.count
    case .newsItem:
      return newsItemContent.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let group = headlineItemGroup[indexPath.section]
    
    if group == .search {
      let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
      cell.searchBar.delegate = self
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
      
      let latestNews = newsItemContent[indexPath.row]
      cell.titleLabel.text = latestNews.title
      cell.tagsLabel.text = "\(latestNews.publishedAt.string(format: "MMMM dd, yyyy h:mm a"))"
      
      let imageUrl = latestNews.urlToImage
      cell.loadingView.startAnimating()
      cell.thumbImageView.kf.setImage(with: URL(string: imageUrl)) { _ in
        cell.loadingView.stopAnimating()
      }
      
      cell.topConstraint.constant = indexPath.row == 0 ? 20 : 10
      cell.bottomConstraint.constant = indexPath.row == newsItemContent.count - 1 ? 20 : 10
      
      return cell
    }
  }
}

// MARK: - UISearchBarDelegate
extension HeadlineViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    search(searchBar.text ?? "")
  }
}

// MARK: - extension UITableViewDelegate
extension HeadlineViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let group = headlineItemGroup[indexPath.section]
    
    if group == .newsItem {
      let listNews = newsItemContent[indexPath.row]
      if let url = URL(string: listNews.url) {
        let viewController = SFSafariViewController(url: url)
        present(viewController, animated: true, completion: nil)
      }
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return headlineItemGroup[indexPath.section] == .newsItem
  }
  
  func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return "Add to Reading List"
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let listNews = newsItemContent[indexPath.row]
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.viewContext
    
    NewsData.insert(news: listNews, context: context)
    appDelegate.saveContext()
  }
}
