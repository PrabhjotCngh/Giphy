//
//  GiphyModel.swift
//  Giphy
//
//  Created by Prabh on 2022-05-21.
//

import Foundation

struct GiphyModel: Codable {
    var data: [GiphyDataModel]
}

struct GiphyDataModel: Codable {
    var id: String
    var url: String
}
