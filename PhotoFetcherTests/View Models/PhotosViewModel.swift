//
//  PhotosViewModel.swift
//  PhotoFetcherTests
//
//  Created by Mohammad on 8/20/19.
//  Copyright © 2019 Mohammadrf. All rights reserved.
//

import XCTest

@testable import PhotoFetcher

class PhotosViewModelTests: XCTestCase {

  func testSearchPhotos() {
    let expectation = self.expectation(description: "success")
    let viewModel = PhotosViewModel(imageService: imageService)
    
    viewModel.search(for: "kitten") { result in
      switch result {
      case .success(let imagesCount):
        XCTAssertEqual(3, imagesCount.totalImages)
        XCTAssertEqual(3, imagesCount.addedImages)
        
        viewModel.fetchMoreResults { result in
          switch result {
          case .success(let imagesCount):
            XCTAssertEqual(2, imagesCount.addedImages)
            XCTAssertEqual(5, imagesCount.totalImages)
          case .error(_):
            XCTFail("Unexpected test result")
          }
          expectation.fulfill()
        }
        
      case .error(_):
        XCTFail("Unexpected test result")
      }
    }
    
    wait(for: [expectation], timeout: 1)
  }
  
}


private extension PhotosViewModelTests {
  
  var imageService: ImageService {
    let firstPageUrls: [URL] = [
      URL(string: "https://test.com/1")!,
      URL(string: "https://test.com/2")!,
      URL(string: "https://test.com/3")!,
    ]
    
    let secondPageUrls: [URL] = [
      URL(string: "https://test.com/4")!,
      URL(string: "https://test.com/5")!,
    ]
    
    let urls: [Int: [URL]] = [
      1: firstPageUrls,
      2: secondPageUrls
    ]
    
    return ImageServiceStub(urls)
  }
}
