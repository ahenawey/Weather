//
//  HomeModels.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 18/04/2018.
//  Copyright (c) 2018 Ahmed Ali Henawey. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreLocation

enum Home {
    struct Location
    {
        struct City: Codable, Equatable {
            var id: String?
            let name: String
            let coordinates: CLLocationCoordinate2D
            
            enum CodingKeys: String, CodingKey {
                case id
                case latitude
                case longitude
                case name
            }
            
            init(name: String,coordinates: CLLocationCoordinate2D) {
                self.coordinates = coordinates
                self.name = name
            }
            
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                name = try values.decode(String.self, forKey: .name)
                
                id = try values.decode(String?.self, forKey: .id)
                let latitude = try values.decode(Double.self, forKey: .latitude)
                let longitude = try values.decode(Double.self, forKey: .longitude)
                coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(id, forKey: .id)
                try container.encode(coordinates.latitude, forKey: .latitude)
                try container.encode(coordinates.longitude, forKey: .longitude)
                try container.encode(name, forKey: .name)
            }
            
            public static func == (lhs: Home.Location.City, rhs: Home.Location.City) -> Bool {
                return lhs.id == rhs.id &&
                    lhs.name == rhs.name &&
                    lhs.coordinates.latitude == rhs.coordinates.latitude &&
                    lhs.coordinates.longitude == rhs.coordinates.longitude
            }
        }
        
        struct Add {
            struct Request
            {
                let city: Home.Location.City
            }
        }
        struct View {
            struct Request
            {
                let city: Home.Location.City?
            }
        }
        struct Remove {
            struct Request
            {
                let cityID: String?
            }
            
            struct Response
            {
                let cityIndex: Int
            }
            struct ViewModel
            {
                let cityIndex: Int
                let cityIndexPath: IndexPath
            }
        }
        struct Retrieve {
            struct Response
            {
                let cities: [Home.Location.City]
            }
        }
        struct ViewModel
        {
            var cities: [Home.Location.City]
        }
        
        enum ValidationError: LocalizedError {
            case selectedCityInvalid
            
            var errorDescription: String? {
                switch self {
                case .selectedCityInvalid:
                    return "Selected City Invalid"
                }
            }
        }
    }
}
