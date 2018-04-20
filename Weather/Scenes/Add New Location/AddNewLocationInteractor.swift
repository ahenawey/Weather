//
//  AddNewLocationInteractor.swift
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

protocol AddNewLocationDelegate {
    func didAddNewCity(city: Home.Location.City)
}

protocol AddNewLocationBusinessLogic
{
    var delegate: AddNewLocationDelegate? { get set }
    func getCityName(request: AddNewLocation.Location.GeoCoder.Request)
    func addCity(request: AddNewLocation.Location.Add.Request)
}

protocol AddNewLocationDataStore
{
}

class AddNewLocationInteractor: AddNewLocationBusinessLogic, AddNewLocationDataStore
{
    var presenter: AddNewLocationPresentationLogic?
    var worker: AddNewLocationWorker?
    var delegate: AddNewLocationDelegate?
    
    
    // MARK: Do something
    
    func getCityName(request: AddNewLocation.Location.GeoCoder.Request)
    {
        let geoCoder = CLGeocoder()
        let mapLocation = CLLocation(latitude: request.coordinate.latitude, longitude: request.coordinate.longitude)
        geoCoder.reverseGeocodeLocation(mapLocation, completionHandler: { [weak self] (placemarks, error) -> Void in
            
            if let error = error {
                self?.presenter?.presentError(error: error)
                return
            }
            
            guard let placeMark = placemarks?.first else {
                self?.presenter?.presentError(error: AddNewLocation.Location.GeoCoder.Error.cannotGetCityName)
                return
            }
            
            self?.presenter?.presentCityName(response: AddNewLocation.Location.GeoCoder.Response(placemark: placeMark))
        })
    }
    
    func addCity(request: AddNewLocation.Location.Add.Request) {
        
        guard let cityName = request.cityName,
            let coordinates = request.cityCoordinate else{
                presenter?.presentError(error: CitiesStoreError.cannotCreate("City invalid"))
                return
        }
        
        worker = AddNewLocationWorker()
        let city = Home.Location.City(name: cityName, coordinates: coordinates)
        worker?.addCity(city: city, completionHandler: { [weak self] (result) in
            switch result {
            case .success(let city):
                self?.delegate?.didAddNewCity(city: city)
                self?.presenter?.presentCityAdded()
            case .failure(let error):
                self?.presenter?.presentError(error: error)
            }
        })
    }
}
