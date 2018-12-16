//
//  ImageHelper.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/14/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit

final class ImageHelper {
  static func fetchImage(urlString: String, completionHandler: @escaping (AppError?, UIImage?) -> Void) {
    NetworkHelper.performDataTask(urlString: urlString, httpMethod: "GET") { (error, data, response) in
      if let error = error {
        completionHandler(error, nil)
      } else if let data = data {
        let image = UIImage(data: data)
        DispatchQueue.main.async {
          completionHandler(nil, image)
        }
      }
    }
    // NSCache - a dictionary that has the ability to cache transient data
    // for performance improvements
    // Use a Singleton to build a wrapper around NSCache
  }
}
// use
// im in a view controller
// ImageHelper.fetchImage(urlString: "https:......") { error, image in }



