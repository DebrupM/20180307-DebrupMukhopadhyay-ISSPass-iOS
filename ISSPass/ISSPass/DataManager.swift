//
//  DataManager.swift
//  ISSPass
//
//  Created by Debrup Mukhopadhyay on 06/03/18.
//  Copyright © 2018 debrup. All rights reserved.
//

import UIKit
import CoreLocation

class DataManager: NSObject {
    
    /** Method to fetch ISS pass times over requested location
     - Parameters:
     - completionClosure: The closure that to call when the data task is complete. This handler is executed on the delegate queue. This completion handler takes the following parameters:
     - success: `Bool` that indicates the success/failure of operation
     - response: Optional `ISSPassTimeModel` object when *success* else `nil` on *error*
     - Returns: `void`
     */
    class func getISSPassTimes(over location: CLLocationCoordinate2D,
                               completionClosure: @escaping(_ success: Bool, _ response: ISSPassTimeModel?, _ error: Error?) -> ())
    {
        // Checking for network availability
        if (!Reachability.isConnectedToNetwork()) {
            let error = NSError(domain: Constants.Error.Network.unavailable, code: 1001, userInfo: nil) as Error
            completionClosure(false, nil, error)
            return
        }
        
        //TODO: use URLComponents instead of hardcoding lat long in URL
        let urlPath = Constants.URL.ISSPassAPI + "lat=\(location.latitude)&lon=\(location.longitude)"
        let url = URL(string: urlPath)!
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config)
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if let error = error {
                // Returning failure closure with error
                completionClosure(false, nil, error)
            } else {
                do {
                    // Parsing return JSON data on success and returning closure with parsed object
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                    let objISSPassTimeModel = DataParser.parseISSPassTimeResponse(data: jsonResult)
                    completionClosure(true, objISSPassTimeModel, nil)
                }
                catch {
                    // Returning failure closure with error
                    let error = NSError(domain: Constants.Error.Network.unavailable, code: 1001, userInfo: nil) as Error
                    completionClosure(false, nil, error)
                }
            }
        });
        
        // Start the session data task
        task.resume()
    }

}
