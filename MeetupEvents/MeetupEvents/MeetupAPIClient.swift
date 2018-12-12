//
//  MeetupAPIClient.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/12/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation

final class MeetupAPIClient {
  
  static func searchEvents(keyword: String) {
    // endpoint
    let urlString = "https://api.meetup.com/find/events?key=\(SecretKeys.APIKey)&fields=group_photo&text=\(keyword)&lat=40.72&lon=-73.84"
    guard let url = URL(string: urlString) else {
      print("badURL: \(urlString)")
      return
    }
    
    // use URLSession() to make network request to MeetupAPI
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let response = response as? HTTPURLResponse {
        print("response status code is \(response.statusCode)")
      }
      if let error = error {
        print("error: \(error)")
      } else if let data = data {
        // decoding of JSON using JSONDecoder()
        // can throw and error so needs to be wrapped in a
        // do{} catch{}
        do {
          let events = try JSONDecoder().decode([Event].self, from: data)
          print("found \(events.count) events")
        } catch {
          print("decoding error: \(error)")
        }
      }
      
    }.resume()
  }
  
  // events you have RSVP'd to , valid values are "yes" or "no"
  static func memberEvents() {
    let urlString = "https://api.meetup.com/self/events?key=\(SecretKeys.APIKey)&page=10&status=upcoming&desc=false&rsvp=yes"
    NetworkHelper.performDataTask(urlString: urlString, httpMethod: "GET") { (error, data) in
      // decode our JSON
      if let error = error {
        print("error: \(error)")
      } else if let data = data {
        do {
          let events = try JSONDecoder().decode([Event].self, from: data)
          print("rsvp\'d to \(events.count) events")
        } catch {
          print("decoding error: \(error)")
        }
      }
    }
  }
  
  static func updateRSVP() {
    let urlString = "https://api.meetup.com/2/rsvp?key=\(SecretKeys.APIKey)&event_id=256944810&rsvp=yes "
  }
  
  
}
