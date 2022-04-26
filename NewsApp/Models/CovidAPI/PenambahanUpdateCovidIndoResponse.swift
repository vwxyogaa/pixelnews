//
//  PenambahanUpdateCovidIndoResponse.swift
//  NewsApp
//
//  Created by macbook on 06/03/22.
//

import Foundation

struct PenambahanUpdateCovidIndoResponse: Decodable {
  let jumlahPositif: Int
  let jumlahMeninggal: Int
  let jumlahSembuh: Int
  let jumlahDirawat: Int
  let tanggal: Date
  
  enum CodingKeys: String, CodingKey {
    case jumlahPositif = "jumlah_positif"
    case jumlahMeninggal = "jumlah_meninggal"
    case jumlahSembuh = "jumlah_sembuh"
    case jumlahDirawat = "jumlah_dirawat"
    case tanggal
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    jumlahPositif = try values.decodeIfPresent(Int.self, forKey: .jumlahPositif) ?? 0
    jumlahMeninggal = try values.decodeIfPresent(Int.self, forKey: .jumlahMeninggal) ?? 0
    jumlahSembuh = try values.decodeIfPresent(Int.self, forKey: .jumlahSembuh) ?? 0
    jumlahDirawat = try values.decodeIfPresent(Int.self, forKey: .jumlahDirawat) ?? 0
    let tanggalString = try values.decodeIfPresent(String.self, forKey: .tanggal) ?? ""
    tanggal = tanggalString.date(format: .date) ?? Date(timeIntervalSince1970: 0)
  }
}
