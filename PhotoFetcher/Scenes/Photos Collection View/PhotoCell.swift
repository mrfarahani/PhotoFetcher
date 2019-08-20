//
//  PhotoCell.swift
//  PhotoFetcher
//
//  Created by Mohammad on 8/20/19.
//  Copyright © 2019 Mohammadrf. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
  
  // MARK: - UI Elements
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: - Initialization
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    tag = Int(arc4random())
  }
  
  // MARK: - UICollectionViewCell
  override func prepareForReuse() {
    super.prepareForReuse()
    tag = Int(arc4random())
    imageView.image = nil
  }

  
  func update(with image: UIImage?) {
    imageView.image = image
    activityIndicator.hidesWhenStopped = true
    activityIndicator.stopAnimating()
  }
  
  func enableLoading() {
    activityIndicator.startAnimating()
  }
}

