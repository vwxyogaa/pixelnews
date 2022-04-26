//
//  TotalUpdateCovidIndoResponse.swift
//  NewsApp
//
//  Created by macbook on 06/03/22.
//

import Foundation

struct TotalUpdateCovidIndoResponse: Decodable {
  let jumlahPositif: Int
  let jumlahDirawat: Int
  let jumlahSembuh: Int
  let jumlahMeninggal: Int
  
  enum CodingKeys: String, CodingKey {
    case jumlahPositif = "jumlah_positif"
    case jumlahDirawat = "jumlah_dirawat"
    case jumlahSembuh = "jumlah_sembuh"
    case jumlahMeninggal = "jumlah_meninggal"
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    jumlahPositif = try values.decodeIfPresent(Int.self, forKey: .jumlahPositif) ?? 0
    jumlahDirawat = try values.decodeIfPresent(Int.self, forKey: .jumlahDirawat) ?? 0
    jumlahSembuh = try values.decodeIfPresent(Int.self, forKey: .jumlahSembuh) ?? 0
    jumlahMeninggal = try values.decodeIfPresent(Int.self, forKey: .jumlahMeninggal) ?? 0
  }
}
