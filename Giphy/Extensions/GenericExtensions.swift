//
//  GenericExtensions.swift
//  Giphy
//
//  Created by Prabh on 2022-05-23.
//

import UIKit

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
