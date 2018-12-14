//
//  ViewController.swift
//  MeetupEvents
//
//  Created by Alex Paul on 12/12/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit

class MeetupEventsController: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  private var events = [Event]() {
    didSet { // use case e.g when searching
      // table view reload data needs to be on the main thread
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    searchBar.delegate = self
    searchEvents(keyword: "ios")
    searchBar.autocapitalizationType = .none    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let indexPath = tableView.indexPathForSelectedRow,
      let meetupDetailController = segue.destination as? MeetupDetailController else { fatalError("indexPath, meeetupDetailController nil")}
    let event = events[indexPath.row]
    meetupDetailController.event = event
  }
  
  private func searchEvents(keyword: String) {
    MeetupAPIClient.searchEvents(keyword: keyword) { (error, events) in
      if let error = error {
        print("error: \(error)")
      } else if let events = events {
        self.events = events
      }
    }
  }
}

extension MeetupEventsController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return events.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
    let event = events[indexPath.row]
    cell.textLabel?.text = event.name
    return cell
  }
}

extension MeetupEventsController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder() // dismiss the keyboard
    guard let searchText = searchBar.text,
      !searchText.isEmpty,
      let searchTextEncoded = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
        return
    }
    searchEvents(keyword: searchTextEncoded)
  }
}

