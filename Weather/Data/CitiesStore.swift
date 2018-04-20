//
//  CitiesStore.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 20/04/2018.
//  Copyright © 2018 Ahmed Ali Henawey. All rights reserved.
//

import Foundation

protocol CitiesStoreProtocol {
    func fetch(completionHandler: @escaping (Result<[Home.Location.City],CitiesStoreError>)->())
    func create(city: Home.Location.City,
                     completionHandler: @escaping (Result<Home.Location.City,CitiesStoreError>)->())
    func delete(id: String,
                     completionHandler: @escaping (Result<Home.Location.City,CitiesStoreError>)->())
    func clearCities(completionHandler: @escaping (Result<Void,CitiesStoreError>)->())
}

protocol CitiesStoreUtilityProtocol {}

extension CitiesStoreUtilityProtocol
{
    func generateCityID(city: inout Home.Location.City)
    {
        guard city.id == nil else { return }
        city.id = "\(arc4random())"
    }
    
}

enum CitiesStoreError: Equatable, Swift.Error
{
    case CannotFetch(String)
    case CannotCreate(String)
    case CannotUpdate(String)
    case CannotDelete(String)
}

