//
//  NetworkManager.swift
//  Giphy
//
//  Created by Prabh on 2022-05-21.
//

import Foundation

let kAPIKey = "crZElh6nsH2m5AFPT0nJ7AlPbmi2FqNn"

struct NetworkManager {
    let router = Router<WebApiType>()

    func fetchTrendingGifs(_ params: [String: Any], success: @escaping (GiphyModel)->(), fail: @escaping (Error)->()) {
        Router().request(WebApiType.fetchGifs(urlParams: params)) { data, response, error in
            if let data = data {
                do {
                    let jsonModel = try JSONDecoder().decode(GiphyModel.self, from: data)
                    success(jsonModel)
                } catch {
                    fail(error)
                }
            }
            
            if let error = error {
                fail(error)
            }
        }
    }
    
    func fetchSearchedGif() {
        
    }
}
