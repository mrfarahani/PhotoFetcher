//
//  CollectionExtensions.swift
//  PhotoFetcher
//
//  Created by Mohammad on 8/20/19.
//  Copyright © 2019 Mohammadrf. All rights reserved.
//

import Foundation

public extension Collection where Index: BinaryInteger {
  subscript (safe index: Index) -> Self.Iterator.Element? {
    guard startIndex <= index && index < endIndex else {
      return nil
    }
    return self[index]
  }
}

