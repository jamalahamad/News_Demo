//
//  DataBaseManager.swift
//  News_Demo
//
//  Created by Jamal Ahamad on 05/02/20.
//  Copyright © 2020 Jamal Ahamad. All rights reserved.
//

import UIKit
import CoreData

class DataBaseManager: NSObject {
    
    var contextMngr: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveData(newsFeeds: [Articles]) {
        let context = contextMngr
        let viewModel = NewsViewModel()
        for i in 0..<newsFeeds.count {
            viewModel.downLoadImage(urlStr: newsFeeds[i].urlToImage ?? "") { (data) in
                let feedEntity = NSEntityDescription.insertNewObject(forEntityName: "NewsFeed", into: context)
                feedEntity.setValue(newsFeeds[i].author, forKey: "author")
                feedEntity.setValue(newsFeeds[i].title, forKey: "title")
                feedEntity.setValue(newsFeeds[i].content, forKey: "content")
                feedEntity.setValue(newsFeeds[i].publishedAt, forKey: "publishedAt")
                feedEntity.setValue(newsFeeds[i].desc, forKey: "desc")

                feedEntity.setValue(data, forKey: "urlToImage")
                feedEntity.setValue(newsFeeds[i].url, forKey: "url")
                do {
                    try context.save()
                    print("save Success")
                } catch {
                    print("Error saving: \(error.localizedDescription)")
                }
            }
        }
        
    }
    
    func fetchData() ->  [NewsCoreDataModel] {
        let contex = self.contextMngr
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsFeed")
        do {
            let feeds = try contex.fetch(fetchReq)
            let  feedsArray = feeds as! [NSManagedObject]
            let dbModel = NewsCoreDataModel()
            var dbModelArray = [NewsCoreDataModel]()
            for feed in feedsArray {
                dbModel.author = feed.value(forKey: "author") as? String
                dbModel.title = feed.value(forKey: "title") as? String
                dbModel.content = feed.value(forKey: "content") as? String
                dbModel.publishedAt = feed.value(forKey: "publishedAt") as? String
                dbModel.url = feed.value(forKey: "url") as? String
                dbModel.desc = feed.value(forKey: "desc") as? String
                dbModel.urlToImage = feed.value(forKey: "urlToImage") as? Data
                dbModelArray.append(dbModel)
            }
            return dbModelArray
        } catch {
            print("error in fetching data: \(error.localizedDescription)")
            return [NewsCoreDataModel]()
        }
    }
    
    func deleteData() {
       let context = contextMngr
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsFeed")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
            print ("successfully deleted")
        } catch {
            print ("There was an error in deleting")
        }
    }

}
