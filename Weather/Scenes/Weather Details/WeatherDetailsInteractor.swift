//
//  WeatherDetailsInteractor.swift
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

protocol WeatherDetailsBusinessLogic
{
  func loadForecast()
}

protocol WeatherDetailsDataStore
{
  var selectedCity: Home.Location.City! { get set }
}

class WeatherDetailsInteractor: WeatherDetailsBusinessLogic, WeatherDetailsDataStore
{
  var presenter: WeatherDetailsPresentationLogic?
  var worker: WeatherDetailsWorker?
  var selectedCity: Home.Location.City!
  
  // MARK: Do someth ing
  
  func loadForecast()
  {
    worker = WeatherDetailsWorker()
    worker?.getWeatherForcast(for: selectedCity.coordinates, useMeteric: Locale.current.usesMetricSystem, completionHandler: { [weak self] (result) in
        guard let strongSelf = self else {
            return
        }
        DispatchQueue.main.async {
            switch result {
            case .success(let forecast):
                let response = WeatherDetails.Response(cityName: strongSelf.selectedCity.name, forecast: forecast)
                self?.presenter?.presentWeatherDetails(response: response)
            case .failure(let error):
                self?.presenter?.presentError(error: error)
            }
        }
    })
  }
}