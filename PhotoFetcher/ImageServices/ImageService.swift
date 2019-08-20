//
//  ImageService.swift
//  PhotoFetcher
//
//  Created by Mohammad on 8/20/19.
//  Copyright © 2019 Mohammadrf. All rights reserved.
//

import Foundation

// Any new service that would be added to the project must conform to this protocol.

public protocol ImageService {
  
  func fetchImageUrls(searchTerm: String, page: Int, completion: @escaping (Result<[URL]>) -> Void)
  func downloadImage(at url: URL, completion: @escaping (Result<Data>) -> Void)
  
}
