//
//  Constants.swift
//  Giphy
//
//  Created by Prabh on 2022-05-21.
//

import Foundation

//MARK: - Static constants for APIs
enum APIConstants {
    static let domain = "http://api.giphy.com/v1/gifs/"
    static let fetchGifsEndPoint = "trending"
    static let searchGifsEndPoint = "search"
}

//MARK: - Static constants for alertView
enum AlertViewConstants {
    static let ok = "OK"
    static let error = "Error"
    static let errorMessage = "Something went wrong please try again later after sometime!"
}
