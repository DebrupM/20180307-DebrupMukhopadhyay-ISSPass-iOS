//
//  DataParser.swift
//  ISSPass
//
//  Created by Debrup Mukhopadhyay on 06/03/18.
//  Copyright © 2018 debrup. All rights reserved.
//

import UIKit

class DataParser: NSObject {
    
    /** Parses a collection of key-value objects into `ISSPassTimeModel` object
     - Parameter arrAttendees: Deserialized ISS pass time response
     - Returns: `ISSPassTimeModel` model object
     */
    class func parseISSPassTimeResponse(data: NSDictionary) -> ISSPassTimeModel {
        let objISSPassTimeModel = ISSPassTimeModel()
        let objRequest = RequestModel()
        let arrResponse = NSMutableArray()
        
        let request = data.value(forKey: "request") as! NSDictionary
        objRequest.latitude = request.object(forKey: "latitude") as? Double
        objRequest.longitude = request.object(forKey: "longitude") as? Double
        objRequest.datetime = request.object(forKey: "datetime") as? Double
        objRequest.passes = request.object(forKey: "passes") as? Int
//        let allKeys = request.allKeys
//        for key in allKeys {
//            let value = request.value(forKey: key as! String) as? Double
//            let modelKey = key as! String
//            objRequest.setValue(value, forKey: modelKey)
//        }
        objISSPassTimeModel.request = objRequest
        
        let response = data.value(forKey: "response") as! NSArray
        for responseElement in response {
            let objResponse = ResponseModel()
            objResponse.duration = (responseElement as! NSDictionary).value(forKey: "duration") as? Double
            objResponse.riseTime = (responseElement as! NSDictionary).value(forKey: "risetime") as? Double
            arrResponse.add(objResponse)
        }
        objISSPassTimeModel.response = arrResponse
        
        return objISSPassTimeModel
    }
    
}
