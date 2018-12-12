//
//  NetworkHelper.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/12/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation

final class NetworkHelper {
  static func performDataTask(urlString: String, httpMethod: String, completionHandler: @escaping (Error?, Data?) ->Void) {
    guard let url = URL(string: urlString) else {
      print("badURL: \(urlString)")
      return
    }
    
    // so far we've been using URL to make network request
    // now we will use URLRequest to make network requests
    // URLRequest gives us the ability to package more metadata
    // into our network request e.g httpMethod type
    
    // metadata: extra information about an object
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    
    // use URLSession to make network request
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      // handle error
      if let error = error {
        completionHandler(error, nil)
      }
      
      // get response status code
      if let response = response as? HTTPURLResponse {
        print("response status code is \(response.statusCode)")
      }
      
      // check for data
      if let data = data {
        completionHandler(nil, data)
      }
    }.resume()
  }
}
