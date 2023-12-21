//
//  NewsModel.swift
//  News_Demo
//
//  Created by Jamal Ahamad on 04/02/20.
//  Copyright © 2020 Jamal Ahamad. All rights reserved.
//

import Foundation
class NewsDataModel: Codable {
    var articles: [Articles]?
    enum CodingKeys: String, CodingKey {
        case articles = "articles"
    }
    
    required init() {
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        articles = try values.decode([Articles].self, forKey: .articles)
        
    }
}

class Articles: Codable {
    var source: Source?
    
    var author: String?
    var title: String?
    var desc: String?
    var url: String?
    var urlToImage: String?
    var content: String?
    var publishedAt: String?
    
    
    enum CodingKeys: String, CodingKey {
        case author = "author"
        case title = "title"
        case desc = "description"
        case url = "url"
        case urlToImage = "urlToImage"
        case content = "content"
        case source = "source"
        case publishedAt = "publishedAt"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        source = try values.decode(Source.self, forKey: .source)
        author = try values.decode(String.self, forKey: .author)
        title = try values.decode(String.self, forKey: .title)
        desc = try values.decode(String.self, forKey: .desc)
        url = try values.decode(String.self, forKey: .url)
        urlToImage = try values.decode(String.self, forKey: .urlToImage)
        if let cont = try values.decodeIfPresent(String.self, forKey: .content) {
            self.content = cont
        } else {
            self.content = "content empty"
        }
        publishedAt = try values.decode(String.self, forKey: .publishedAt)
    }
}

class Source: Codable {
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
    }
    
}
