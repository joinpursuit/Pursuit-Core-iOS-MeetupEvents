//
//  MeetupAPIClient.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/12/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation

final class MeetupAPIClient {
  
  static func searchEvents(keyword: String, completionHandler: @escaping (Error?, [Event]?) -> Void) {
    // endpoint
    let urlString = "https://api.meetup.com/find/upcoming_events?key=\(SecretKeys.APIKey)&fields=group_photo&text=\(keyword)"
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
        completionHandler(error, nil)
      } else if let data = data {
        // decoding of JSON using JSONDecoder()
        // can throw and error so needs to be wrapped in a
        // do{} catch{}
        do {
          let eventData = try JSONDecoder().decode(EventData.self, from: data)
          // closure captures value from network response
          completionHandler(nil, eventData.events)
        } catch {
          completionHandler(error, nil)
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
  
  static func updateRSVP(eventId: String,
                         rsvpStatus: String,
                         completionHandler: @escaping(Error?, RSVP?) -> Void) {
    let urlString = "https://api.meetup.com/2/rsvp?key=\(SecretKeys.APIKey)&event_id=\(eventId)&rsvp=\(rsvpStatus)"
    NetworkHelper.performDataTask(urlString: urlString, httpMethod: "POST") { (error, data) in
      if let error = error {
        completionHandler(error, nil)
      } else if let data = data {
        do {
          let rsvp = try JSONDecoder().decode(RSVP.self, from: data)
          completionHandler(nil, rsvp)
        } catch {
          completionHandler(error, nil)
        }
      }
    }
  }
}
