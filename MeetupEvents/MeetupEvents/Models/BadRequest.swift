//
//  BadRequest.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/16/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation

/*
 {
 "details": "You must be a member of this group to RSVP to the event.",
 "problem": "Your command could not be completed"
 }
*/

struct BadRequest: Codable {
  let details: String
  let problem: String
}
