//
//  GifDetailItem.swift
//  Giphy
//
//  Created by Prabh on 2022-05-23.
//

import Foundation

class GifDetailItem: Hashable {
    var url: String
    var id: String
    
    init(url: String, id: String) {
        self.url = url
        self.id = id
    }

    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }

    static func == (lhs: GifDetailItem, rhs: GifDetailItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private let identifier = UUID()
}
