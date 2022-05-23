//
//  GiphyCollectionViewCell.swift
//  Giphy
//
//  Created by Prabh on 2022-05-21.
//

import UIKit

class GiphyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ivImageView: UIImageView!
    
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
        ivImageView.backgroundColor = .red
    }
}

//MARK: - Configure cell methods
extension GiphyCollectionViewCell {
    func configure() {
        guard let gifURL = self.gifURL else { return }
        let gifImage = UIImage.gifImageWithURL(gifURL)
        ivImageView.image = gifImage
    }
}
