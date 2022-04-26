//
//  ArticlesIndoNewsResponse.swift
//  NewsApp
//
//  Created by macbook on 04/03/22.
//

import Foundation

struct ArticlesIndoNewsResponse: Decodable {
  let title: String
  let author: String?
  let urlToImage: String
  let publishedAt: Date
  let source: ArticleSourceIndoNewsResponse?
  let url: String
  let content: String
  
  enum CodingKeys: String, CodingKey {
    case title
    case author
    case urlToImage
    case publishedAt
    case source
    case url
    case content
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
    author = try values.decodeIfPresent(String.self, forKey: .author)
    urlToImage = try values.decodeIfPresent(String.self, forKey: .urlToImage) ?? ""
    let publishedAtString = try values.decodeIfPresent(String.self, forKey: .publishedAt) ?? ""
    publishedAt = publishedAtString.date(format: .dateTimeISO8601) ?? Date(timeIntervalSince1970: 0)
    source = try values.decodeIfPresent(ArticleSourceIndoNewsResponse.self, forKey: .source)
    url = try values.decodeIfPresent(String.self, forKey: .url) ?? ""
    content = try values.decodeIfPresent(String.self, forKey: .content) ?? ""
  }
}
