//
//  HTTPTask.swift
//  Giphy
//
//  Created by Prabh on 2022-05-21.
//

import Foundation
import Alamofire

public enum HTTPTask {
    case upload
    
    case requestWith(bodyParameters: Parameters?, urlParameters : Parameters?)
    
    case request
}
