//
//  String+Extensions.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/14/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation

extension String {
  // instance method on the String object
  public func stripHTML() -> String {
    return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
  }
  
  // input String date e.g 2018-12-19 - from Meetup JSON
  // output e.g Decemeber 19, 2018
  static func formattedDate(str: String) -> String {
    var formattedString = str
    // DateFormatter()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    // create a Date()
    if let date = dateFormatter.date(from: formattedString) {
      dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
      formattedString = dateFormatter.string(from: date)
    } else {
      print("formattedDate: invalid date")
    }
    return formattedString
  }
}
