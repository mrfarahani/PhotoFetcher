//
//  NetworkServiceStub.swift
//  PhotoFetcherTests
//
//  Created by Mohammad on 8/20/19.
//  Copyright © 2019 Mohammadrf. All rights reserved.
//

import XCTest

@testable import PhotoFetcher

class ImageServiceStub {

  var imageUrlsPerPage = [Int: [URL]]()
  
  init(_ imageUrlsPerPage: [Int: [URL]]? = nil) {
    if let imageUrlsPerPage = imageUrlsPerPage {
      self.imageUrlsPerPage = imageUrlsPerPage
    }
  }
  
}

extension ImageServiceStub: ImageService {
  func fetchImageUrls(searchTerm: String, page: Int, completion: @escaping (Result<[URL]>) -> Void) {
    if let urls = imageUrlsPerPage[page] {
      completion(.success(urls))
    } else {
      completion(.error(.internalError))
    }
  }
  

  func downloadImage(at url: URL, completion: @escaping (Result<Data>) -> Void) {
    completion(.error(.internalError))
  }
  
}
