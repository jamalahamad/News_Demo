//
//  Constants.swift
//  News_Demo
//
//  Created by Jamal Ahamad on 04/02/20.
//  Copyright © 2020 Jamal Ahamad. All rights reserved.
//

import Foundation
// https://newsapi.org/v2/everything?apiKey=3145d60eaf18468ea2a92b6875f9cb51&q=google&language=en&pageSize=2&page=10
struct Constants {
    static let newsUrl =  "https://newsapi.org/v2/everything?apiKey=3145d60eaf18468ea2a92b6875f9cb51&q=google&language=en&pageSize=1&page=1"
    static let baseUrl = "https://newsapi.org/v2/everything"
    static let apiKey    = "3145d60eaf18468ea2a92b6875f9cb51"
    static let headerKey = "3145d60eaf18468ea2a92b6875f9cb51"

}
struct GenerateQuery {
    
    func generateUrl(language: String? = "en", pageSize: String? = "1", page: String? = "1") -> [URLQueryItem] {
        var items = [URLQueryItem]()
        items.append(URLQueryItem(name: "apiKey", value: "\(Constants.apiKey)"))
        items.append(URLQueryItem(name: "q", value: "google"))
        items.append(URLQueryItem(name: "language", value: "\(language ?? "")"))
        items.append(URLQueryItem(name: "pageSize", value: "\(pageSize ?? "")"))
        items.append(URLQueryItem(name: "page", value: "\(page ?? "")"))
        
        return items
    }
}
