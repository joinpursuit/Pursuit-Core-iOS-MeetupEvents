//
//  MeetupDetailController.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/14/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit

class MeetupDetailController: UIViewController {
  
  @IBOutlet weak var eventImage: UIImageView!
  @IBOutlet weak var eventDescription: UITextView!
  @IBOutlet weak var eventLocalDate: UILabel!
  @IBOutlet weak var rsvpStatusLabel: UILabel!
  
  private var rsvpStatus = ""
  public var event: Event!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateEventUI()
    fetchScheduledEvents()
  }
  
  private func fetchScheduledEvents() {
    MeetupAPIClient.memberEvents { (error, events) in
      if let error = error {
        print(error.errorMessage())
      } else if let events = events {
        let results = events.filter { $0.id == self.event.id }
        DispatchQueue.main.async {
          self.rsvpStatusLabel.text = results.first != nil ? "You have RSVP'd to this event" : "You have not RSVP's to this event"
          self.rsvpStatusLabel.textColor = results.first != nil ? .orange : .black
          self.rsvpStatus = results.first != nil ? "yes" : "no"
        }
      }
    }
  }
  
  private func updateEventUI() {
    title = event.name
    if let description  = event.description {
      eventDescription.text = description.stripHTML()
    }
    
    if let dateString = event.localDate {
      eventLocalDate.text = String.formattedDate(str: dateString)
    } else {
      eventLocalDate.text = "no date available"
    }
    
    if let url = event.group.photo?.photo_link {
      ImageHelper.fetchImage(urlString: url.absoluteString) { (error, image) in
        if let error = error {
          print(error.errorMessage())
        } else if let image = image {
          self.eventImage.image = image
        }
      }      
    } else {
      eventImage.image = UIImage(named: "placeholderImage")
    }
  }
  
  @IBAction func updateRSVP(_ sender: UIButton) {
    rsvpStatus = rsvpStatus == "yes" ? "no" : "yes"
    MeetupAPIClient.updateRSVP(eventId: event.id, rsvpStatus: rsvpStatus) { (error, rsvp, badRequest) in
      if let error = error {
        print(error.errorMessage())
      } else if let rsvp = rsvp {
        DispatchQueue.main.async {
          self.rsvpStatusLabel.text = rsvp.response == "yes" ? "You have RSVP'd to this event" : "You have not RSVP's to this event"
          self.rsvpStatusLabel.textColor = rsvp.response == "yes" ? .orange : .black
        }
      } else if let badRequest = badRequest {
        DispatchQueue.main.async {
          self.rsvpStatusLabel.text = badRequest.details
        }
      }
    }
  }
  
}
