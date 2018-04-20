//
//  UserDefaultCitiesDataStore.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 20/04/2018.
//  Copyright © 2018 Ahmed Ali Henawey. All rights reserved.
//

import UIKit

class UserDefaultCitiesDataStore: CitiesStoreProtocol, CitiesStoreUtilityProtocol {
    
    private let citiesKeys = "cities"
    
    func fetch(completionHandler: @escaping (Result<[Home.Location.City], CitiesStoreError>) -> ()) {
        if let cities = UserDefaults.standard.array(forKey: citiesKeys) as? [Home.Location.City] {
            completionHandler(.success(cities))
        } else {
            completionHandler(.success([]))
        }
    }
    
    func create(city: Home.Location.City,
                completionHandler: @escaping (Result<Home.Location.City,CitiesStoreError>)->()) {
        var city = city
        generateCityID(city: &city)
        
        var outputCities: [Home.Location.City]
        
        if let cities = UserDefaults.standard.array(forKey: citiesKeys) as? [Home.Location.City] {
            outputCities = cities
            outputCities.append(city)
            completionHandler(.success(city))
        } else {
            outputCities = [city]
            completionHandler(.success(city))
        }
        UserDefaults.standard.set(outputCities ,forKey: citiesKeys)
        UserDefaults.standard.synchronize()
    }
    
    func delete(id: String,
                completionHandler: @escaping (Result<Home.Location.City,CitiesStoreError>)->()) {
        var outputCities: [Home.Location.City]
        
        if let cities = UserDefaults.standard.array(forKey: citiesKeys) as? [Home.Location.City] {
            outputCities = cities
            if let id = cities.index(where: { $0.id == id }) {
                let removedItem = outputCities.remove(at: id)
                completionHandler(.success(removedItem))
                UserDefaults.standard.set(outputCities ,forKey: citiesKeys)
                UserDefaults.standard.synchronize()
                return
            }
        }
        
        completionHandler(.failure(.CannotDelete("No Item Found with id = \(id)")))
    }
    
    func clearCities(completionHandler: @escaping (Result<Void,CitiesStoreError>)->()) {
        UserDefaults.standard.removeObject(forKey: citiesKeys)
        completionHandler(.success(()))
    }
}
