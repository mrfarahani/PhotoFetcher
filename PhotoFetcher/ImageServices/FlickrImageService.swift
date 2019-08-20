//
//  FlickrImageService.swift
//  PhotoFetcher
//
//  Created by Mohammad on 8/20/19.
//  Copyright © 2019 Mohammadrf. All rights reserved.
//

import UIKit

class FlickrImageService {

  // MARK: - Properties
  private let apiKey = "a7ff2547f62a0a15e033af73b92f44a2"
  private let imagesFetchCountPerPage = 40
  
  let networkService: NetworkServiceType
  
  // MARK: - Initializer
  init(networkService: NetworkServiceType) {
    self.networkService = networkService
  }

}

// MARK: - ImageService implementation
extension FlickrImageService: ImageService {

  func fetchImageUrls(searchTerm: String, page: Int, completion: @escaping (Result<[URL]>) -> Void) {
    guard let request = imageUrlsRequest(text: searchTerm, page: page) else {
      completion(.error(.internalError))
      return
    }
    
    URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
      let result: Result<[URL]>
      if let error = error as? Error {
        result = Result.error(error)
        completion(result)
      } else {
          guard let data = data else {
            completion(.error(.requestError))
            return
          }
        
          do {
            guard let resultsDictionary = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject] else {
              completion(.error(.requestError))
              return
            }

            guard
              let photosContainer = resultsDictionary["photos"] as? [String: AnyObject],
              let photosReceived = photosContainer["photo"] as? [[String: AnyObject]]
              else {
                DispatchQueue.main.async {
                  completion(Result.error(.requestError))
                }
                return
            }
            
            let flickrPhotosUrl: [URL] = photosReceived.compactMap { photoObject in
              guard
                let photoID = photoObject["id"] as? String,
                let farm = photoObject["farm"] as? Int,
                let server = photoObject["server"] as? String,
                let secret = photoObject["secret"] as? String
                else {
                  return nil
              }
              
              let flickrPhoto = FlickrPhoto(photoID: photoID, farm: farm, server: server, secret: secret)
              return flickrPhoto.flickrImageURL()
            }
            
            result = Result.success(flickrPhotosUrl)
            completion(result)
          }
          catch {
            guard let error = error as? Error else {
              return
            }
            completion(Result.error(error))
            return
          }
        }
      }.resume()
  }
  
  func downloadImage(at url: URL, completion: @escaping (Result<Data>) -> Void) {
    networkService.downloadImage(at: url) { result in
      DispatchQueue.main.async {
        completion(result)
      }
    }
  }
  
}

// MARK: - Flickr URLRequest Helper
extension FlickrImageService {
  var urlComponents: URLComponents {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.flickr.com"
    urlComponents.path = "/services/rest"
    urlComponents.queryItems = [
      URLQueryItem(name: "api_key", value: apiKey),
      URLQueryItem(name: "format", value: "json"),
      URLQueryItem(name: "nojsoncallback", value: "1"),
      URLQueryItem(name: "per_page", value: String(imagesFetchCountPerPage))
    ]
    return urlComponents
  }
  
  func imageUrlsRequest(text: String, page: Int) -> URLRequest? {
    var components = urlComponents
    components.queryItems?.append(contentsOf: [
      URLQueryItem(name: "method", value: "flickr.photos.search"),
      URLQueryItem(name: "safe_search", value: "1"),
      URLQueryItem(name: "text", value: text),
      URLQueryItem(name: "page", value: String(page))
      ])
    
    return NetworkService.jsonRequest(urlComponents: components)
  }
}
