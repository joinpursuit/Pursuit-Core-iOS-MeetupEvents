//
//  ViewController.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/12/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit

class MeetupEventsController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    MeetupAPIClient.searchEvents(keyword: "ios")
    
    MeetupAPIClient.memberEvents()
  }


}

