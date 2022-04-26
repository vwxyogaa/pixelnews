//
//  IndoNewsResponse.swift
//  NewsApp
//
//  Created by macbook on 04/03/22.
//

import Foundation

struct IndoNewsResponse: Decodable {
  let articles: [ArticlesIndoNewsResponse]
  
  enum CodingKeys: String, CodingKey {
    case articles
  }
}
