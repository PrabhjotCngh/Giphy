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
    var images: GiphyImagesModel
}

struct GiphyImagesModel: Codable {
    var original: GiphyOriginalModel
}

struct GiphyOriginalModel: Codable {
    var url: String
}

