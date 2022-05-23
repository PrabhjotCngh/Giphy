//
//  WebAPIEndPoints.swift
//  Giphy
//
//  Created by Prabh on 2022-05-21.
//

import Foundation
import Alamofire

public enum WebApiType {
    case fetchGifs(urlParams: [String: Any])
    case searchGifs(urlParams: [String: Any])
}

extension WebApiType: EndPointType {

    var environmentBaseURL : String {
        switch self {
        case .fetchGifs:
            return APIConstants.domain
        case .searchGifs:
            return APIConstants.domain
        }
    }

    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .fetchGifs:
            return APIConstants.fetchGifsEndPoint
        case .searchGifs:
            return APIConstants.searchGifsEndPoint
        }
    }
       
    var httpMethod: HTTPMethod {
        switch self {
        case .fetchGifs:
            return .get
        case .searchGifs:
            return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .fetchGifs(let urlParams):
            return .requestWith(bodyParameters: nil, urlParameters: urlParams)
        case .searchGifs(let urlParams):
            return .requestWith(bodyParameters: nil, urlParameters: urlParams)
        }
    }
      
    var headers: HTTPHeaders? {
        switch self {
        case .fetchGifs:
            return nil
        case .searchGifs:
            return nil
        }
    }
}
