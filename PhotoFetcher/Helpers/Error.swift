//
//  Error.swift
//  PhotoFetcher
//
//  Created by Mohammad on 8/20/19.
//  Copyright © 2019 Mohammadrf. All rights reserved.
//

import Foundation

public enum Error: Swift.Error {
  case internalError
  case malformedResponse
  case requestError
  case unknown
}
