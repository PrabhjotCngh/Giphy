//
//  SearchViewModel.swift
//  Giphy
//
//  Created by Prabh on 2022-05-23.
//

import Foundation

class SearchViewModel {
    /// Public Instances
    var searchedGifsList = [GiphyDataModel]()
    
    /// Public Closures
    var success: ()->() = {}
    var fail: (String)->() = {_ in}
    
}

extension SearchViewModel {
    func searchGifs(with queryString: String) {
        let params = ["api_key":kAPIKey, "q": queryString]
        NetworkManager().fetchSearchedGifs(params) { [weak self] response in
            if let _StrongSelf = self {
                _StrongSelf.searchedGifsList.append(contentsOf: response.data)
                _StrongSelf.success()
            }
        } fail: { [weak self] error in
            if let _StrongSelf = self {
                _StrongSelf.fail(error.localizedDescription)
            }
        }
    }
}
