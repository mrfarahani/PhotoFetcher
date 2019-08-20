//
//  Result.swift
//  PhotoFetcher
//
//  Created by Mohammad on 8/20/19.
//  Copyright © 2019 Mohammadrf. All rights reserved.
//

import Foundation

public enum Result<T> {
  case success(T)
  case error(Error)
}

