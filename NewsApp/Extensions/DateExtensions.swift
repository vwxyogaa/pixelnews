//
//  DateExtensions.swift
//  NewsApp
//
//  Created by macbook on 08/03/22.
//

import Foundation

extension Date {
  var valueDefaultDate: Date {
    return Date(timeIntervalSince1970: 0)
  }
  
  func string(format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }
}
