//
//  WeatherDetailsWorker.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 21/04/2018.
//  Copyright (c) 2018 Ahmed Ali Henawey. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreLocation

class WeatherDetailsWorker
{
    fileprivate let dataSource: WeatherStoreProtocol
    
    init(dataSource: WeatherStoreProtocol = MobileAPIWeatherStore()) {
        self.dataSource = dataSource
    }
    
    func getWeatherForcast(for coordinate: CLLocationCoordinate2D,useMeteric: Bool, completionHandler: @escaping (Result<WeatherDetails.Forecast, WeatherStoreError>) -> ()) {
        dataSource.fetch(coordinate: coordinate, useMeteric: useMeteric, completionHandler: completionHandler)
    }
}
