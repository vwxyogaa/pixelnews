//
//  CovidIndoProvider.swift
//  NewsApp
//
//  Created by macbook on 06/03/22.
//

import Foundation
import Alamofire

let baseUrlCovidIndo = "https://data.covid19.go.id/public/api/update.json"

class CovidIndoProvider {
  static let shared: CovidIndoProvider = CovidIndoProvider()
  private init() { }
  
  func loadCovidIndo(completion: @escaping (Result<UpdateCovidIndoResponse, Error>) -> Void) {
    AF.request(
      baseUrlCovidIndo,
      method: .get
    ).responseData { dataResponse in
      if let data = dataResponse.data {
        do {
          let response = try JSONDecoder().decode(CovidIndoResponse.self, from: data)
          completion(.success(response.update))
        } catch {
          completion(.failure(error))
        }
      } else {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Oops! Something went wrong"])
        completion(.failure(error))
      }
    }
  }
}
