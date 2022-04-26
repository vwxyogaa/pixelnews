//
//  NewsData+CoreDataClass.swift
//  NewsApp
//
//  Created by macbook on 05/03/22.
//
//

import Foundation
import CoreData

@objc(NewsData)
public class NewsData: NSManagedObject {
  
  class func insert(news: ArticlesIndoNewsResponse, context: NSManagedObjectContext) {
    let request: NSFetchRequest<NewsData> = NewsData.fetchRequest()
    request.predicate = NSPredicate(format: "url == %@", news.url)
    let entity: NewsData
    if let news = try? context.fetch(request).first {
      entity = news
    } else {
      let news = NSEntityDescription.entity(forEntityName: "NewsData", in: context)!
      entity = NSManagedObject(entity: news, insertInto: context) as! NewsData
    }
    
    entity.title = news.title
    entity.publishedAt = news.publishedAt
    entity.url = news.url
    entity.urlToImage = news.urlToImage
    entity.sourceName = news.source?.name ?? ""
    entity.author = news.author
    entity.content = news.content
  }
  
  class func select(context: NSManagedObjectContext) -> [NewsData] {
    let request: NSFetchRequest<NewsData> = NewsData.fetchRequest()
    do {
      let readingList = try context.fetch(request)
      return readingList
    } catch {
      return []
    }
  }
}
