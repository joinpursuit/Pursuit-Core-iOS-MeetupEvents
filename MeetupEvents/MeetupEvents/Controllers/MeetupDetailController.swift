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
  
  public var event: Event!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateEventUI()
    
    
    // testing rsvp
    MeetupAPIClient.updateRSVP(eventId: "256944810", rsvpStatus: "no") { (error, rsvp) in
      if let error = error {
        print("error: \(error)")
      } else if let rsvp = rsvp {
        print("event response is \(rsvp.response)")
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
          print("image error: \(error)")
        } else if let image = image {
          self.eventImage.image = image
        }
      }      
    } else {
      eventImage.image = UIImage(named: "placeholderImage")
    }
  }
}
