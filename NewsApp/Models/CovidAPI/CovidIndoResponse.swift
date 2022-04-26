//
//  CovidIndoResponse.swift
//  NewsApp
//
//  Created by macbook on 06/03/22.
//

import Foundation

struct CovidIndoResponse: Decodable {
  let update: UpdateCovidIndoResponse
  
  enum CodingKeys: String, CodingKey {
    case update
  }
}
