//
//  ViewController.swift
//  ISSPass
//
//  Created by Debrup Mukhopadhyay on 06/03/18.
//  Copyright © 2018 debrup. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let locationManager = CLLocationManager()
    var objPassModel = ISSPassTimeModel()
    
    // MARK: - View lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setting up location manager to request location only when app in use
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // Adding pull down to refresh control on tableview to refetch location
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.black
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .allEvents)
        tableView.refreshControl = refreshControl
        
        // Tableview workaround to prevent showing separators for empty filler rows
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Helper methods
    
    /// Method to pass captured location to get the ISS pass times over it
    ///
    /// - Parameter location: captured coordinates
    func getISSPassTimes(over location: CLLocationCoordinate2D) {
        showActivityIndicator(withTitle: "Loading")
        
        // Calling network method
        DataManager.getISSPassTimes(over: location) { (success, data, err) in
            if success {
                if let data = data {
                    // Unwrap and save parsed API response in model property
                    self.objPassModel = data
                    
                    // Reload UI on main thread
                    DispatchQueue.main.async {
                        // Check if the refresh control is active, if yes stop it
                        if (self.tableView.refreshControl?.isRefreshing)! {
                            self.tableView.isUserInteractionEnabled = true
                            self.tableView.refreshControl?.endRefreshing()
                        }
                        self.hideActivityIndicator()
                        self.tableView.reloadData()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    
                    // Check if the refresh control is active, if yes stop it
                    if (self.tableView.refreshControl?.isRefreshing)! {
                        self.tableView.isUserInteractionEnabled = true
                        self.tableView.refreshControl?.endRefreshing()
                    }
                    
                    // Show alert on failure
                    let alert = UIAlertController(title: "Oops",
                                                  message: Constants.Message.unknown,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    /// Called when tableview is pulled down to refresh
    @objc func refreshTableData() {
        let formatter =  DateFormatter.init()
        formatter.dateFormat = "MMM d, h:mm a"
        let title = NSString.init(format: "Updating on %@", formatter.string(from: Date.init()))
        let dictAttributes = NSDictionary.init(object: UIColor.white, forKey: NSAttributedStringKey.foregroundColor as NSCopying)
        let strAttributes = NSAttributedString.init(string: title as String, attributes: dictAttributes as? [NSAttributedStringKey : Any])
        tableView.refreshControl?.attributedTitle = strAttributes
        
        tableView.isUserInteractionEnabled = false
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - TableView delegates and data sources
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Handle UI while async operation finishes
        if let passes = objPassModel.response {
            return passes.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Handle UI while async operation finishes
        if let info = objPassModel.request {
            return "\(info.passes!) passes over \(info.latitude!), \(info.longitude!)"
        } else {
            return "Data unavailable. Pull down to refresh."
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"issPassCell", for: indexPath)
        
        // Configure cell while handling nil cases
        if let response = objPassModel.response {
            let pass  = response[indexPath.row] as! ResponseModel
            cell.textLabel?.text = pass.riseTimeString
            cell.detailTextLabel?.text = pass.durationString
        }
        return cell
    }
    
    
    // MARK: - LocationManager delegates
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check the location authorized status
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        } else if status == .denied {
            let alert = UIAlertController(title: "Oops",
                                          message: Constants.Message.locationDisabled,
                                          preferredStyle: .alert)
            // Add alert action to redirect to settings appropriately
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                if !CLLocationManager.locationServicesEnabled() {
                    if let url = URL(string: Constants.URL.LocationPref) {
                        // If general location settings are disabled then open general location settings
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                } else {
                    if let url = URL(string: UIApplicationOpenSettingsURLString) {
                        // If general location settings are enabled then open location settings for the app
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }))
            // Add cancel action
            alert.addAction(UIAlertAction(title: "Not now", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Once location is captured, stop updating and pass the coordinated to APIs
        if locations.count > 0 {
            manager.stopUpdatingLocation()
            getISSPassTimes(over: locations[0].coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Check if the refresh control is active, if yes stop it
        if (self.tableView.refreshControl?.isRefreshing)! {
            self.tableView.isUserInteractionEnabled = true
            self.tableView.refreshControl?.endRefreshing()
        }
        
        manager.stopUpdatingLocation()
        
        // Show failure alert
        let alert = UIAlertController(title: "Oops",
                                      message: Constants.Message.unknown,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

