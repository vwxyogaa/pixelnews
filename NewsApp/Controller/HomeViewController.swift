//
//  HomeViewController.swift
//  NewsApp
//
//  Created by macbook on 24/02/22.
//

import UIKit
import Kingfisher
import SafariServices

enum HomeItemGroup {
  case covid
  case newsForYou
  case listNews
}

class HomeViewController: UIViewController {
  @IBOutlet weak var tableViewHome: UITableView!
  @IBOutlet weak var textLogoLabel: UILabel!
  weak var topNewsCollectionView: UICollectionView?
  weak var pageControl: UIPageControl?
  
  lazy var activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.hidesWhenStopped = true
    if #available(iOS 13.0, *) {
      activityIndicator.style = .large
    }
    return activityIndicator
  }()
  
  var homeItemGroup: [HomeItemGroup] = [.covid, .newsForYou, .listNews]
  
  var covidNewsContent: UpdateCovidIndoResponse?
  var newsForYouContent: [ArticlesIndoNewsResponse] = []
  var listNewsContent: [ArticlesIndoNewsResponse] = []
  
  lazy var buttonProfile: UIButton = {
    let button = UIButton(type: .system)
    
    if #available(iOS 13.0, *) {
      button.setImage(UIImage(systemName: "person.fill"), for: .normal)
      button.tintColor = UIColor.black
    } else {
      // Fallback on earlier versions
    }
    
    button.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
    button.addTarget(self, action: #selector(profileButtonTapped(_:)), for: .touchUpInside)
    
    let barItem = UIBarButtonItem(customView: button)
    navigationItem.rightBarButtonItem = barItem
    
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableViewHome.dataSource = self
    tableViewHome.delegate = self
    tableViewHome.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsCell")
    
    setup()
    setupActivityIndicator()
    view.addSubview(buttonProfile)
    
    loadNewsForYou()
    loadListNews()
  }
  
  // MARK: - Helpers
  func loadNewsForYou() {
    activityIndicator.startAnimating()
    IndoNewsProvider.shared.loadTopHeadlineNews { response in
      switch response {
      case .success(let topNews):
        self.newsForYouContent = topNews
        self.activityIndicator.stopAnimating()
        self.tableViewHome.reloadData()
      case .failure(let error):
        print("Error load top news: \(error.localizedDescription)")
      }
    }
  }
  
  func loadListNews() {
    activityIndicator.startAnimating()
    IndoNewsProvider.shared.loadListNews(pageSize: 10) { response in
      switch response {
      case .success(let listNews):
        self.listNewsContent = listNews
        self.activityIndicator.stopAnimating()
        self.tableViewHome.reloadData()
      case .failure(let error):
        print("Error load news: \(error.localizedDescription)")
      }
    }
  }
  
  func addToReadingList(_ news: ArticlesIndoNewsResponse) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.viewContext
    
    NewsData.insert(news: news, context: context)
    appDelegate.saveContext()
  }
  
  func setup() {
    let attText = NSMutableAttributedString(
      string: "Pixel",
      attributes: [
        .font : UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold),
        .foregroundColor : UIColor(hex: "0077B6")
      ]
    )
    attText.append(NSAttributedString(
      string: " News",
      attributes: [
        .font : UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.medium),
        .foregroundColor : UIColor(hex: "000000")
      ])
    )
    
    textLogoLabel.attributedText = attText
  }
  
  @objc func profileButtonTapped(_ sender: UIButton) {
    print("Profile button tapped")
  }
  
  private func setupActivityIndicator() {
    view.addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
}

// MARK: - extension UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return homeItemGroup.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let group = homeItemGroup[section]
    switch group {
    case .covid:
      return 1
    case .newsForYou:
      return 1
    case .listNews:
      return listNewsContent.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let group = homeItemGroup[indexPath.section]
    
    if group == .covid {
      let cell = tableView.dequeueReusableCell(withIdentifier: "covidCell", for: indexPath) as! CovidNewsTableViewCell
      
      let attText = NSMutableAttributedString(
        string: "Covid-19 News : ",
        attributes: [
          NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold),
          NSAttributedString.Key.foregroundColor : UIColor(hex: "0077B6")
        ]
      )
      attText.append(NSMutableAttributedString(
        string: "See the latest coverage about Covid-19",
        attributes: [
          .font : UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular),
          .foregroundColor : UIColor(hex: "7F7F7F")
        ])
      )
      
      cell.titleLabel.attributedText = attText
      
      cell.topConstraint.constant = indexPath.row == 0 ? 20 : 10
      cell.bottomConstraint.constant = indexPath.row == 1 - 1 ? 20 : 10
      
      return cell
    } else if group == .newsForYou {
      let cell = tableView.dequeueReusableCell(withIdentifier: "topNewsCell", for: indexPath) as! TopNewsTableViewCell
      
      cell.titleLabel.text = "News for you"
      cell.subtitleLabel.text = "Top \(newsForYouContent.count) News of the day"
      
      cell.collectionView.dataSource = self
      cell.collectionView.delegate = self
      cell.collectionView.reloadData()
      
      self.topNewsCollectionView = cell.collectionView
      
      cell.pageControl.currentPage = 0
      cell.pageControl.numberOfPages = newsForYouContent.count
      self.pageControl = cell.pageControl
      
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
      
      let listNews = listNewsContent[indexPath.row]
      cell.titleLabel.text = listNews.title
      cell.tagsLabel.text = "\(listNews.publishedAt.string(format: "MMMM dd, yyyy h:mm a"))"
      
      let imageUrl = listNews.urlToImage
      cell.loadingView.startAnimating()
      cell.thumbImageView.kf.setImage(with: URL(string: imageUrl)) { _ in
        cell.loadingView.stopAnimating()
      }
      
      cell.topConstraint.constant = indexPath.row == 0 ? 20 : 10
      cell.bottomConstraint.constant = indexPath.row == listNewsContent.count - 1 ? 20 : 10
      
      return cell
    }
  }
}

// MARK: extension UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let group = homeItemGroup[indexPath.section]
    
    if group == .covid {
      let detailStoryboard = UIStoryboard(name: "CovidDetail", bundle: nil)
      if let detail = detailStoryboard.instantiateViewController(withIdentifier: "rootCovidDetail") as? CovidDetailViewController {
        
        detail.covidDetail = covidNewsContent
        
        self.navigationController?.pushViewController(detail, animated: true)
      }
    } else if group == .listNews {
      let listNews = listNewsContent[indexPath.row]
      if let url = URL(string: listNews.url) {
        let viewController = SFSafariViewController(url: url)
        present(viewController, animated: true, completion: nil)
      }
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return homeItemGroup[indexPath.section] == .listNews
  }
  
  func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return "Add to Reading List"
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let listNews = listNewsContent[indexPath.row]
    addToReadingList(listNews)
  }
}

// MARK: - extension UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return newsForYouContent.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topNewsCell", for: indexPath) as! TopNewsCollectionViewCell
    
    let listNews = newsForYouContent[indexPath.item]
    let imageUrl = listNews.urlToImage
    cell.loadingView.startAnimating()
    cell.imageView.kf.setImage(with: URL(string: imageUrl)) { _ in
      cell.loadingView.stopAnimating()
    }
    cell.titleLabel.text = listNews.title
    cell.tagsLabel.text = "\(listNews.publishedAt.string(format: "MMMM dd, yyyy h:mm a"))"
    cell.bookmarkButton.setTitle("", for: .normal)
    cell.bookmarkButton.isEnabled = true
    
    cell.delegate = self
    return cell
  }
}

// MARK: - extension TopNewsCollectionViewCellDelegate
extension HomeViewController: TopNewsCollectionViewCellDelegate {
  func TopNewsCollectionViewCellBookmarkButtonTapped(_ cell: TopNewsCollectionViewCell) {
    if let collectionView = cell.superCollectionView, let indexPath = collectionView.indexPath(for: cell) {
      let news = newsForYouContent[indexPath.item]
      addToReadingList(news)
      
      cell.bookmarkButton.isEnabled = false
    }
  }
}

// MARK: - extension UIView
extension UIView {
  var superCollectionView: UICollectionView? {
    if let superview = superview {
      if superview is UICollectionView {
        return superview as? UICollectionView
      }
      else {
        return superview.superCollectionView
      }
    }
    return nil
  }
}

// MARK: - extension UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let listNews = newsForYouContent[indexPath.item]
    if let url = URL(string: listNews.url) {
      let viewController = SFSafariViewController(url: url)
      present(viewController, animated: true, completion: nil)
    }
  }
}

// MARK: - extension UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = UIScreen.main.bounds.width
    return CGSize(width: width, height: 265)
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if scrollView == self.topNewsCollectionView {
      let page = scrollView.contentOffset.x / scrollView.frame.width
      pageControl?.currentPage = Int(page)
    }
  }
}
