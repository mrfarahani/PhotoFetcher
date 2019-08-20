//
//  FlickrPhotoTests.swift
//  PhotoFetcherTests
//
//  Created by Mohammad on 8/20/19.
//  Copyright © 2019 Mohammadrf. All rights reserved.
//

import XCTest

@testable import PhotoFetcher

class FlickrPhotoTests: XCTestCase {
  
  func test_FlickrPhoto_init_shouldReturnValidUrl() {
    let flickrPhoto = FlickrPhoto(photoID: "11223344", farm: 10, server: "9999", secret: "700a800")
    let expectedImageUrl = URL(string: "https://farm10.staticflickr.com/9999/11223344_700a800_m.jpg")!
    XCTAssertEqual(flickrPhoto.flickrImageURL(), expectedImageUrl)
  }
  
  func test_FlickrPhoto_withDifferentIDs_shouldNotBeEqual() {
    let flickrPhoto1 = FlickrPhoto(photoID: "11223344", farm: 10, server: "9999", secret: "700a800")
    let flickrPhoto2 = FlickrPhoto(photoID: "1122334455", farm: 10, server: "9999", secret: "700a800")
    
    XCTAssertNotEqual(flickrPhoto1, flickrPhoto2)
  }

  func test_FlickrPhoto_withSameIDs_shouldBeEqual() {
    let flickrPhoto1 = FlickrPhoto(photoID: "11223344", farm: 10, server: "9999", secret: "700a800")
    let flickrPhoto2 = FlickrPhoto(photoID: "11223344", farm: 100, server: "9999", secret: "700a800")
    
    XCTAssertEqual(flickrPhoto1, flickrPhoto2)
  }

}
