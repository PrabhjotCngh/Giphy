//
//  GiphyCollectionViewCell.swift
//  Giphy
//
//  Created by Prabh on 2022-05-21.
//

import UIKit
import SDWebImage

class GiphyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ivImageView: SDAnimatedImageView!
    
    var gifURL: String? {
      didSet {
        configure()
      }
    }
    
    /// returning cell nib name
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
          
    /// returning cell identifier
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ivImageView.backgroundColor = .gray.withAlphaComponent(0.1)
    }
}

//MARK: - Configure cell methods
extension GiphyCollectionViewCell {
    func configure() {
        guard let gifURLString = self.gifURL else { return }
        guard let gifURL = URL(string: gifURLString) else { return }
        ivImageView.sd_setImage(with: gifURL)
    }
}
