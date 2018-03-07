//
//  ISSPassTimeModel.swift
//  ISSPass
//
//  Created by Debrup Mukhopadhyay on 06/03/18.
//  Copyright © 2018 debrup. All rights reserved.
//

import UIKit

class ISSPassTimeModel: NSObject {
    var request: RequestModel?
    var response: NSArray?
}

class RequestModel: NSObject {
    var latitude: Double?
    var longitude: Double?
    var altitude: Double?
    var passes: Int?
    var datetime: Double?
    var dateTimeString: String? {
        guard let datetime = datetime else { return nil }
        let date = NSDate(timeIntervalSince1970: datetime)
        return DateFormatter.localizedString(from: date as Date, dateStyle: DateFormatter.Style.long, timeStyle: DateFormatter.Style.long)
    }
}

class ResponseModel: NSObject {
    var riseTime: Double?
    var duration: Double?
    var riseTimeString: String? {
        guard let riseTime = riseTime else { return nil }
        let date = NSDate(timeIntervalSince1970: riseTime)
        return DateFormatter.localizedString(from: date as Date, dateStyle: DateFormatter.Style.long, timeStyle: DateFormatter.Style.long)
    }
    var durationString: String? {
        guard let duration = duration else { return nil }
        return "\(duration) seconds"
//        let minutes = Int(duration/60)
//        let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
//        return "\(minutes)m \(seconds)s"
    }
}
