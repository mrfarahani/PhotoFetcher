//
//  PhotosViewModel.swift
//  PhotoFetcher
//
//  Created by Mohammad on 8/20/19.
//  Copyright © 2019 Mohammadrf. All rights reserved.
//

import UIKit

class PhotosViewModel: NSObject {
  private let imageService: ImageService
  var imageUrls: [URL] = []
  
  private var searchTerm = ""
  private var nextSearchPage = 0

  init(imageService: ImageService) {
    self.imageService = imageService
  }
  
  func getImage(for url: URL, completion: @escaping (Result<UIImage>) -> Void) {
    imageService.downloadImage(at: url) { (result: Result<Data>) in
      switch result {
      case .success(let data):
        if let image = UIImage(data: data) {
          completion(.success(image))
        }
      case.error(let error):
        completion(.error(error))
      }
    }
  }
  
  func search(for term: String, completion: @escaping (Result<ImagesCount>) -> Void) {
    nextSearchPage = 1
    searchTerm = term
    fetchImages(completion: completion)
  }
  
  func fetchImages(completion: @escaping (Result<ImagesCount>) -> Void) {
    guard !searchTerm.isEmpty, nextSearchPage > 0 else {
      completion(.error(.internalError))
      return
    }
    
    imageService.fetchImageUrls(searchTerm: searchTerm, page: nextSearchPage) {
      [weak self] (result: Result<[URL]>) in
      
      switch result {
      case .success(let urls):
        self?.nextSearchPage += 1
        var addedImages = 0
        
        if self?.nextSearchPage == 2 {
          // new search query, remove all images
          self?.imageUrls.removeAll()
        }
        for url in urls {
            self?.imageUrls.append(url)
            addedImages += 1
          }
        completion(.success(ImagesCount(totalImages: self?.imageUrls.count ?? 0, addedImages: addedImages)))
      case .error(let error):
        completion(.error(error))
      }
    }
  }
  
  func fetchMoreResults(completion: @escaping (Result<ImagesCount>) -> Void) {
    fetchImages { result in
      completion(result)
    }
  }

}
