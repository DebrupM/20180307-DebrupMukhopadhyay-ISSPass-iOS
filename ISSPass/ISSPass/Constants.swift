//
//  Constants.swift
//  ISSPass
//
//  Created by Debrup Mukhopadhyay on 06/03/18.
//  Copyright © 2018 debrup. All rights reserved.
//

import UIKit


struct Constants {
    
    struct URL {
        static let ISSPassAPI = "http://api.open-notify.org/iss-pass.json?"
        static let LocationPref = "App-Prefs:root=Privacy&path=LOCATION"
    }
    
    struct Error {
        struct Network {
            static let unavailable = "No Network Available."
        }
        struct Data {
            static let corrupt = "Corrupt Data. Please contact admin."
        }
    }
    
    struct Message {
        static let unknown = "Unable to fetch data. Please retry after some time."
        static let locationDisabled = "Location settings are required to get ISS pass times. Do you want to allow access?"
    }
}
