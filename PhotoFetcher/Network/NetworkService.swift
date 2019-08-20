//
//  NetworkService.swift
//  PhotoFetcher
//
//  Created by Mohammad on 8/20/19.
//  Copyright © 2019 Mohammadrf. All rights reserved.
//

import Foundation

protocol NetworkServiceType {
  
  func downloadImage(at url: URL, completion: @escaping (Result<Data>) -> Void)
  
}

class NetworkService {
  
  // MARK: - URLCache Constants
  private let memoryCapacity = 200 * 1024 * 1024 // 200 MB
  private let diskCapacity = 600 * 1024 * 1024 // 600 MB
  
  // MARK: - URLSession
  private var cacheEnabledURLSession: URLSession?
  
  func initCacheEnabledURLSession() {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .returnCacheDataElseLoad
    configuration.urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity,
                                      diskPath: "CachedImages")
    cacheEnabledURLSession = URLSession(configuration: configuration)
  }
  
  // MARK: - JSON Request
  enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
  }
  
  static func jsonRequest(urlComponents: URLComponents, method: HttpMethod = .get, body: Data? = nil) -> URLRequest? {
    guard let url = urlComponents.url else {
      return nil
    }
    
    var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
    request.httpMethod = method.rawValue
    request.httpBody = body
    return request
  }
}

// MARK: - NetworkServiceType implementation
extension NetworkService: NetworkServiceType {
  func downloadImage(at url: URL, completion: @escaping (Result<Data>) -> Void) {
    if cacheEnabledURLSession == nil {
      initCacheEnabledURLSession()
    }
    
    cacheEnabledURLSession?.dataTask(with: url) { (data, response, error) -> Void in
      let result: Result<Data>
      if let error = error as? Error {
        result = .error(error)
      } else if let data = data {
        result = .success(data)
      } else {
        result = .error(.malformedResponse)
      }
      completion(result)
      }.resume()
  }
}

