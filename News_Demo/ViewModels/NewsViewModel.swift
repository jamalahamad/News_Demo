
//
//  NewsViewModel.swift
//  News_Demo
//
//  Created by Jamal Ahamad on 04/02/20.
//  Copyright © 2020 Jamal Ahamad. All rights reserved.
//

import Foundation

var languageTitleRray = [(language.english, "en"), (language.arabic, "ar"), (language.german, "de"), (language.spanish, "es"), (language.french, "fr"), (language.italian, "it"), (language.portuguese, "pt")]

public enum language: String {
    case english = "english"
    case arabic = "arabic"
    case german = "german"
    case spanish = "spanish"
    case french = "french"
    case italian = "italian"
    case portuguese = "portuguese"
}

class NewsViewModel {
    
    var networkManager = NetworkManager.shared
    
    func getNewsData(pages: String, language: String, pageSize: String, completion: @escaping (NewsDataModel?, Error?)->()) {
        let query = GenerateQuery()
        let queryItem = query.generateUrl(language: language, pageSize: pageSize, page: pages)
        let urlComp = NSURLComponents(string: Constants.baseUrl)!
        urlComp.queryItems = queryItem
        var request = URLRequest(url: urlComp.url!)
        request.httpMethod = "GET"

        networkManager.genericAPIGETRequest(returnType: NewsDataModel.self, urlReq: request) { (newsModelArray, error) in
            if error == nil {
                completion(newsModelArray, nil)
            } else {
                completion(NewsDataModel(), error)
            }
        }
    }
    
    func downLoadImage(urlStr: String, completion: @escaping (Data)->()){
           guard  let url = URL(string: urlStr) else {
               return
           }
           let task = URLSession.shared.dataTask(with: url) { data, response, error in
               guard let data = data, error == nil else { return }
               completion(data)
           }
           task.resume()
       }
}
