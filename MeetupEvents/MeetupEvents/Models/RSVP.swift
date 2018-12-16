//
//  RSVP.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/14/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation

struct RSVP: Codable {
  struct Venue: Codable {
    let country: String
    let localized_country_name: String
    let city: String
    let address_1: String
    let name: String
    let lon: Double
    let id: Int
    let state: String
    let lat: Double
    let repinned: Bool
  }
  let venue: Venue?
  let created: TimeInterval
  let response: String
  let rsvp_id: Int
}
