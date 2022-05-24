//
//  ViewController.swift
//  Giphy
//
//  Created by Prabh on 2022-05-21.
//

import UIKit

class SearchViewController: UIViewController {

    /// IBOutlets
    @IBOutlet weak var sbSearchview: UISearchBar!
    @IBOutlet weak var cvCollectionView: UICollectionView!
    @IBOutlet weak var vEmptyStateView: UIView!

    /// Private instances
    private let viewModel = SearchViewModel()
    
    /// ViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.cvCollectionView.isHidden = true
        callbackHandler()
        cvCollectionView.register(GiphyCollectionViewCell.nib, forCellWithReuseIdentifier: GiphyCollectionViewCell.identifier)
    }
}
 
//MARK: - Callback handler methods
extension SearchViewController {
    func callbackHandler() {
        /// Listen to success callback from viewModel
        viewModel.success = {
            DispatchQueue.main.async {
                self.cvCollectionView.isHidden = false
                if self.viewModel.searchedGifsList.count <= 0 {
                    self.cvCollectionView.isHidden = true
                }
                self.cvCollectionView.reloadData()
            }
        }
        
        /// Listen to fail callback from viewModel
        viewModel.fail = { error in
            DispatchQueue.main.async {
                Utility.displayAlert(title: AlertViewConstants.error, message: AlertViewConstants.errorMessage)
            }
        }
    }
}

//MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchedGifsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GiphyCollectionViewCell.identifier, for: indexPath) as? GiphyCollectionViewCell else { return UICollectionViewCell() }
        if viewModel.searchedGifsList.count >= indexPath.row {
            cell.gifURL = viewModel.searchedGifsList[indexPath.row].images.original.url
        }
        return cell
    }
    
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            viewModel.searchGifs(with: searchText)
            viewModel.searchedGifsList.removeAll()
            cvCollectionView.reloadData()
        } else {
            cvCollectionView.isHidden = true
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = view.frame.width-4
        let height  = view.frame.height/4
        return CGSize(width: width, height: height)
    }
}
