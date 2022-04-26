//
//  UpdateCovidIndoResponse.swift
//  NewsApp
//
//  Created by macbook on 06/03/22.
//

import Foundation

struct UpdateCovidIndoResponse: Decodable {
  let penambahan: PenambahanUpdateCovidIndoResponse
  let total: TotalUpdateCovidIndoResponse
  
  enum CodingKeys: String, CodingKey {
    case penambahan
    case total
  }
}
