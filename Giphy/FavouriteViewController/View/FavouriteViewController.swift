//
//  FavouriteViewController.swift
//  Giphy
//
//  Created by Prabh on 2022-05-21.
//

import UIKit

class FavouriteViewController: UIViewController {
    /// IBOutlets
    @IBOutlet weak var cvCollectionView: UICollectionView!
    
    /// Public instances
    var dataSource: UICollectionViewDiffableDataSource<CollectionViewSections, GifDetailItem>! = nil

    /// Private instances
    private let viewModel = FavouriteViewModel()
    
    /// ViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.getTrendingGifs()
        configureCollectionView()
        configureDataSource()
        callbackHandler()
    }

}

//MARK: - Callback handler methods
extension FavouriteViewController {
    func callbackHandler() {
        /// Listen to success callback from viewModel
        viewModel.success = {
            DispatchQueue.main.async {
                self.dataSource.replaceItems(self.viewModel.gifDetailItemsList, in: .giphyBody)
            }
        }
        
        /// Listen to fail callback from viewModel
        viewModel.fail = { error in
            
        }
    }
}

//MARK: - CollectionView data source methods
extension FavouriteViewController {
    /// CollectionView is configured here
    func configureCollectionView() {
        cvCollectionView.collectionViewLayout = generateLayout()
        cvCollectionView.register(GiphyCollectionViewCell.nib, forCellWithReuseIdentifier: GiphyCollectionViewCell.identifier)
    }
    
    /// Data is configured here
    func configureDataSource() {
      dataSource = UICollectionViewDiffableDataSource
        <CollectionViewSections, GifDetailItem>(collectionView: cvCollectionView) {
          (collectionView: UICollectionView, indexPath: IndexPath, detailItem: GifDetailItem) -> UICollectionViewCell? in
          guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GiphyCollectionViewCell.identifier,
            for: indexPath) as? GiphyCollectionViewCell else { fatalError("Could not create new cell") }
            cell.gifURL = detailItem.url
          return cell
      }
        // load our initial data
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    /// CollectionView layout is configured here
    func generateLayout() -> UICollectionViewLayout {
      // We have three row styles
      // Style 1: 'Full'
      // A full width photo
      // Style 2: 'Main with pair'
      // A 2/3 width photo with two 1/3 width photos stacked vertically
      // Style 3: 'Triplet'
      // Three 1/3 width photos stacked horizontally

      // Full
      let fullPhotoItem = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .fractionalWidth(2/3)))
      fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

      // Main with pair
      let mainItem = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(2/3),
          heightDimension: .fractionalHeight(1.0)))
      mainItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

      let pairItem = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .fractionalHeight(0.5)))
      pairItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
      let trailingGroup = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1/3),
          heightDimension: .fractionalHeight(1.0)),
        subitem: pairItem,
        count: 2)

      let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .fractionalWidth(4/9)),
        subitems: [mainItem, trailingGroup])

      // Triplet
      let tripletItem = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1/3),
          heightDimension: .fractionalHeight(1.0)))
      tripletItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

      let tripletGroup = NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .fractionalWidth(2/9)),
        subitems: [tripletItem, tripletItem, tripletItem])

      // Reversed main with pair
      let mainWithPairReversedGroup = NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .fractionalWidth(4/9)),
        subitems: [trailingGroup, mainItem])

      let nestedGroup = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .fractionalWidth(16/9)),
        subitems: [fullPhotoItem, mainWithPairGroup, tripletGroup, mainWithPairReversedGroup])

      let section = NSCollectionLayoutSection(group: nestedGroup)
      let layout = UICollectionViewCompositionalLayout(section: section)
      return layout
    }
    
    /// Snapshot is configured here
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<CollectionViewSections, GifDetailItem> {
      var snapshot = NSDiffableDataSourceSnapshot<CollectionViewSections, GifDetailItem>()
      snapshot.appendSections([CollectionViewSections.giphyBody])
      return snapshot
    }
}

//MARK: - UICollectionViewDelegate
extension FavouriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

//MARK: - UICollectionViewDiffableDataSource
extension UICollectionViewDiffableDataSource {
    /// Find current snapshot, delete and replace item from it
    func replaceItems(_ items : [ItemIdentifierType], in section: SectionIdentifierType) {
        var currentSnapshot = snapshot()
        let itemsOfSection = currentSnapshot.itemIdentifiers(inSection: section)
        currentSnapshot.deleteItems(itemsOfSection)
        currentSnapshot.appendItems(items, toSection: section)
        currentSnapshot.reloadSections([section])
        apply(currentSnapshot, animatingDifferences: true)
    }
}
