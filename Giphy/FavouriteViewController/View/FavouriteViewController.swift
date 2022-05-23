//
//  FavouriteViewController.swift
//  Giphy
//
//  Created by Prabh on 2022-05-21.
//

import UIKit

class GifDetailItem: Hashable {
    var giphyModel: [Int]
    
    init(giphyModel: [Int]) {
      self.giphyModel = giphyModel
    }

    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }

    static func == (lhs: GifDetailItem, rhs: GifDetailItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private let identifier = UUID()
}

class FavouriteViewController: UIViewController {
    enum Section {
      case giphyBody
    }
    
    var item = [GifDetailItem]()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, GifDetailItem>! = nil
    @IBOutlet weak var cvCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getTopGifsList()
        configureCollectionView()
        configureDataSource()
    }

}

extension FavouriteViewController {
    func configureCollectionView() {
        cvCollectionView.collectionViewLayout = generateLayout()
        cvCollectionView.register(GiphyCollectionViewCell.nib, forCellWithReuseIdentifier: GiphyCollectionViewCell.identifier)
    }
    
    func configureDataSource() {
      dataSource = UICollectionViewDiffableDataSource
        <Section, GifDetailItem>(collectionView: cvCollectionView) {
          (collectionView: UICollectionView, indexPath: IndexPath, detailItem: GifDetailItem) -> UICollectionViewCell? in
          guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GiphyCollectionViewCell.identifier,
            for: indexPath) as? GiphyCollectionViewCell else { fatalError("Could not create new cell") }
            cell.gifURL = "\(detailItem.giphyModel[indexPath.row])"
          return cell
      }
        // load our initial data
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
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
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, GifDetailItem> {
      var snapshot = NSDiffableDataSourceSnapshot<Section, GifDetailItem>()
        let test = Array(0...100)
        item = [GifDetailItem(giphyModel: test), GifDetailItem(giphyModel: test), GifDetailItem(giphyModel: test), GifDetailItem(giphyModel: test)]
        snapshot.appendSections([Section.giphyBody])
        snapshot.appendItems(item)
      return snapshot
    }
    
    func getTopGifsList() {
        let params = ["api_key":kAPIKey]
        NetworkManager().fetchTrendingGifs(params) { [weak self] response in
            
            if let _StrongSelf = self {
//                let test = Array(0...100)
//                _StrongSelf.item = [GifDetailItem(giphyModel: test)]//[GifDetailItem(giphyModel: response.data)]
//                DispatchQueue.main.async {
//                    _StrongSelf.dataSource.replaceItems(_StrongSelf.item, in: .giphyBody)
//                }
            }
        } fail: { [weak self] error in
            if let _StrongSelf = self {
            }
        }
    }
}

extension FavouriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension UICollectionViewDiffableDataSource {
    
    func replaceItems(_ items : [ItemIdentifierType], in section: SectionIdentifierType) {
        var currentSnapshot = snapshot()
        let itemsOfSection = currentSnapshot.itemIdentifiers(inSection: section)
        currentSnapshot.deleteItems(itemsOfSection)
        currentSnapshot.appendItems(items, toSection: section)
        currentSnapshot.reloadSections([section])
        apply(currentSnapshot, animatingDifferences: true)
    }
}
