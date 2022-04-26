//
//  ArticleSourceIndoNewsResponse.swift
//  NewsApp
//
//  Created by macbook on 04/03/22.
//

import Foundation

struct ArticleSourceIndoNewsResponse: Decodable {
  let name: String
  
  enum CodingKeys: String, CodingKey {
    case name
  }
}
