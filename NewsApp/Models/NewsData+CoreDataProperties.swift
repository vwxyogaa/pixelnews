//
//  NewsData+CoreDataProperties.swift
//  NewsApp
//
//  Created by macbook on 07/03/22.
//
//

import Foundation
import CoreData


extension NewsData {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsData> {
    return NSFetchRequest<NewsData>(entityName: "NewsData")
  }
  
  @NSManaged public var publishedAt: Date
  @NSManaged public var sourceName: String
  @NSManaged public var title: String
  @NSManaged public var url: String
  @NSManaged public var urlToImage: String
  @NSManaged public var author: String?
  @NSManaged public var content: String
}
