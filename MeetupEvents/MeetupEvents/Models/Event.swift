//
//  Event.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/12/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation

struct EventData: Codable {
  let events: [Event]
}

struct Event: Codable {
  let created: TimeInterval?
  let duration: TimeInterval?
  let id: String
  let name: String
  let status: String?
  let time: TimeInterval
  let localDate: String?
  let localTime: String? // local_time
  let updated: TimeInterval?
  let waitListCount: Int?
  let yesRSVPCount: Int?
  // using enum CodingKeys to change property names
  private enum CodingKeys: String, CodingKey {
    case created
    case duration
    case id
    case name
    case status
    case time
    case localDate = "local_date" // type alias
    case localTime = "local_time"
    case updated
    case waitListCount = "waitlist_count"
    case yesRSVPCount = "yes_rsvp_count"
    case venue
    case group
    case link
    case description
    case visibility
  }
  struct Venue: Codable {
    let id: Int
    let name: String
    let lat: Double
    let lon: Double
    let repinned: Bool
    let address_1: String
    let city: String
    let country: String
    let localized_country_name: String
    let zip: String?
    let state: String?
    // TODO: coding keys
  }
  let venue: Venue?
  struct Group: Codable {
    let created: TimeInterval
    let name: String
    let id: Int
    let join_mode: String
    let lat: Double
    let lon: Double
    let urlname: String
    let who: String
    let localized_location: String
    let state: String
    let country: String
    let region: String
    let timezone: String
    struct Photo: Codable {
      let id: Int
      let highres_link: URL
      let photo_link: URL
      let thumb_link: URL
      let type: String
      let base_url: URL
    }
    let photo: Photo?
  }
  let group: Group
  let link: URL
  let description: String?
  let visibility: String
}
