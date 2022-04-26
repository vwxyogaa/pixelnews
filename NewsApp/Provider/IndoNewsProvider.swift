//
//  IndoNewsProvider.swift
//  NewsApp
//
//  Created by macbook on 04/03/22.
//

import Foundation
import Alamofire

let baseUrlNewsApi = "https://newsapi.org/v2"
private var apiKey: String {
  get {
    guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
      fatalError("Couldn't find file 'Info.plist'.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: "API_KEY") as? String else {
      fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
    }
    return value
  }
}

class IndoNewsProvider {
  static let shared: IndoNewsProvider = IndoNewsProvider()
  private init() { }
  
  func loadTopHeadlineNews(completion: @escaping (Result<[ArticlesIndoNewsResponse], Error>) -> Void) {
    AF.request(
      "\(baseUrlNewsApi)/top-headlines",
      method: .get,
      parameters: [
        "pageSize": "10",
        "country": "id",
        "apiKey": apiKey
      ]
    ).responseData { dataResponse in
      if let data = dataResponse.data {
        do {
          let response = try JSONDecoder().decode(IndoNewsResponse.self, from: data)
          completion(.success(response.articles))
        } catch {
          completion(.failure(error))
        }
      } else {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Oops! Something went wrong"])
        completion(.failure(error))
      }
    }
  }
  
  func loadListNews(pageSize: Int, completion: @escaping (Result<[ArticlesIndoNewsResponse], Error>) -> Void) {
    AF.request(
      "\(baseUrlNewsApi)/everything",
      method: .get,
      parameters: [
        "pageSize": pageSize,
        "domains": "detik.com,cnnindonesia.com,tribunnews.com",
        "apiKey": apiKey
      ]
    ).responseData { dataResponse in
      if let data = dataResponse.data {
        do {
          let response = try JSONDecoder().decode(IndoNewsResponse.self, from: data)
          completion(.success(response.articles))
        } catch {
          completion(.failure(error))
        }
      } else {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Oops! Something went wrong"])
        completion(.failure(error))
      }
    }
  }
  
  func loadDetailListNews(domains: String, completion: @escaping (Result<[ArticlesIndoNewsResponse], Error>) -> Void) {
    AF.request(
      "\(baseUrlNewsApi)/everything",
      method: .get,
      parameters: [
        "domains": domains,
        "apiKey": apiKey
      ]
    ).responseData { dataResponse in
      if let data = dataResponse.data {
        do {
          let response = try JSONDecoder().decode(IndoNewsResponse.self, from: data)
          completion(.success(response.articles))
        } catch {
          completion(.failure(error))
        }
      } else {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Oops! Something went wrong"])
        completion(.failure(error))
      }
    }
  }
  
  func searchNews(query: String, completion: @escaping (Result<[ArticlesIndoNewsResponse], Error>) -> Void) {
    AF.request(
      "\(baseUrlNewsApi)/everything",
      method: .get,
      parameters: [
        "q": query,
        "sortBy": "popularity",
        "apiKey": apiKey
      ]
    ).validate().responseDecodable(of: IndoNewsResponse.self) { response in
      switch response.result {
      case .success(let data):
        completion(.success(data.articles))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
