//
//  AddNewLocationModels.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 20/04/2018.
//  Copyright (c) 2018 Ahmed Ali Henawey. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreLocation

enum AddNewLocation
{
  // MARK: Use cases
  
  enum Location
  {
    struct Add {
        struct Request
        {
            let cityName: String?
            let cityCoordinate: CLLocationCoordinate2D?
        }
    }
    
    struct GeoCoder {
        struct Request
        {
            let coordinate: CLLocationCoordinate2D
        }
        struct Response
        {
            let placemark: CLPlacemark
        }
        struct ViewModel
        {
            let cityName: String
        }
        
        enum Error: LocalizedError {
            case cannotGetCityName
            
            var errorDescription: String?{
                switch self {
                case .cannotGetCityName:
                    return "Cannot get city name"
                }
            }
        }
    }
  }
}
