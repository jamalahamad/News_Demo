//
//  NetworkManager.swift
//  News_Demo
//
//  Created by Jamal Ahamad on 04/02/20.
//  Copyright © 2020 Jamal Ahamad. All rights reserved.
//

import Foundation

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private init (){}
    
    func genericAPIGETRequest<T: Codable>(returnType: T.Type, urlReq: URLRequest, completionBlock: @escaping (T?, Error?) -> ()) {
        
        URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    self.handleNetworkError(error: error, response: response)
                    let response = try decoder.decode(T.self, from: data)
                    completionBlock(response.self, nil)
                } catch {
                    print("error in parsing : \(String(describing: error.localizedDescription))")
                    completionBlock(nil, error)
                }
            } else {
                self.handleNetworkError(error: error, response: response)
                print("no readable data in response : \(String(describing: error?.localizedDescription))")
                completionBlock(nil, error)
            }
        } .resume()
    }
    
    private func handleNetworkError(error: Error?, response: URLResponse?) {     // handles errors returned from URLResponse
        if let err = error {
            devLog("APTMobileNetworkManager returned network error \(err.localizedDescription)")
        }
        
        if let myResponse = response as? HTTPURLResponse {
            devLog("Response code: \(myResponse.statusCode))")
            devLog("Response headers: \(myResponse.allHeaderFields))")
        }
    }
    
    func devLog(_ item: Any) {
        #if DEBUG
            print(item)
        #endif
    }
}
