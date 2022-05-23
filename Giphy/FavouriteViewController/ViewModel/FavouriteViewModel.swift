//
//  FavouriteViewModel.swift
//  Giphy
//
//  Created by Prabh on 2022-05-21.
//

import Foundation

enum CollectionViewSections {
  case giphyBody
}

class FavouriteViewModel {
    /// Public Instances
    var gifDetailItemsList = [GifDetailItem]()
    
    /// Public Closures
    var success: ()->() = {}
    var fail: (String)->() = {_ in}

}

//MARK: - API requests
extension FavouriteViewModel {
    /// Fetch Trending Gifs list
    func getTrendingGifs() {
        let params = ["api_key":kAPIKey]
        NetworkManager().fetchTrendingGifs(params) { [weak self] response in
            if let _StrongSelf = self {
                for item in response.data {
                    _StrongSelf.gifDetailItemsList.append(contentsOf: [GifDetailItem(url: item.images.original.url, id: item.id)])
                }
                _StrongSelf.success()
            }
        } fail: { [weak self] error in
            if let _StrongSelf = self {
                _StrongSelf.fail(error.localizedDescription)
            }
        }
    }
}
