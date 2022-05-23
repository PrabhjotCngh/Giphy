//
//  EndPointType.swift
//  Giphy
//
//  Created by Prabh on 2022-05-21.
//

import Foundation
import Alamofire

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
