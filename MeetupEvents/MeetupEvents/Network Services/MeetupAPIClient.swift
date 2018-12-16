//
//  MeetupAPIClient.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/12/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation

final class MeetupAPIClient {
  
  static func searchEvents(keyword: String, completionHandler: @escaping (AppError?, [Event]?) -> Void) {
    let urlString = "https://api.meetup.com/find/upcoming_events?key=\(SecretKeys.APIKey)&fields=group_photo&text=\(keyword)"
    NetworkHelper.performDataTask(urlString: urlString, httpMethod: "GET") { (error, data, response) in
      if let error = error {
        completionHandler(error, nil)
      } else if let data = data {
        do {
          let eventData = try JSONDecoder().decode(EventData.self, from: data)
          // closure captures value from network response
          completionHandler(nil, eventData.events)
        } catch {
          completionHandler(AppError.decodingError(error), nil)
        }
      }
    }
  }
  
  // events you have RSVP'd to , valid values are "yes" or "no"
  static func memberEvents(completionHandler: @escaping (AppError?, [Event]?) -> Void) {
    let urlString = "https://api.meetup.com/self/events?key=\(SecretKeys.APIKey)&page=10&status=upcoming&desc=false&rsvp=yes"
    NetworkHelper.performDataTask(urlString: urlString, httpMethod: "GET") { (error, data, response) in
      if let error = error {
        completionHandler(error, nil)
      } else if let data = data {
        do {
          let events = try JSONDecoder().decode([Event].self, from: data)
          completionHandler(nil, events)
        } catch {
          completionHandler(AppError.decodingError(error), nil)
        }
      }
    }
  }
  
  static func updateRSVP(eventId: String,
                         rsvpStatus: String,
                         completionHandler: @escaping(AppError?, RSVP?, BadRequest?) -> Void) {
    let urlString = "https://api.meetup.com/2/rsvp?key=\(SecretKeys.APIKey)&event_id=\(eventId)&rsvp=\(rsvpStatus)"
    NetworkHelper.performDataTask(urlString: urlString, httpMethod: "POST") { (error, data, response) in
      if let error = error {
        completionHandler(error, nil, nil)
      } else if let data = data {
        guard let response = response else {
          return
        }
        if response.statusCode >= 200 && response.statusCode < 300 {
          do {
            let rsvp = try JSONDecoder().decode(RSVP.self, from: data)
            completionHandler(nil, rsvp, nil)
          } catch {
            completionHandler(AppError.decodingError(error), nil, nil)
          }
        } else {
          // bad request - we need to use the BadRequest Model here
          do {
            let badRequest = try JSONDecoder().decode(BadRequest.self, from: data)
            completionHandler(nil, nil, badRequest)
          } catch {
            completionHandler(AppError.decodingError(error), nil, nil)
          }
        }
      }
    }
  }
}
