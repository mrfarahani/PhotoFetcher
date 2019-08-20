//
//  UICollectionViewExtensions.swift
//  PhotoFetcher
//
//  Created by Mohammad on 8/20/19.
//  Copyright © 2019 Mohammadrf. All rights reserved.
//

import UIKit

extension UICollectionView {
  
  func setEmptyMessage(_ message: String) {
    let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
    messageLabel.text = message
    messageLabel.textColor = .gray
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    messageLabel.font = UIFont(name: "TrebuchetMS", size: 18)
    messageLabel.sizeToFit()
    
    self.backgroundView = messageLabel;
  }
  
  func restore() {
    self.backgroundView = nil
  }
}
