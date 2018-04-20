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
    
    private func fetchCitiesSync() throws -> [Home.Location.City] {
        guard let rawCities = UserDefaults.standard.object(forKey: citiesKeys) as? Data else {
            return []
        }
        
        return try JSONDecoder().decode([Home.Location.City].self, from: rawCities)
    }
    
    func fetch(completionHandler: @escaping (Result<[Home.Location.City], CitiesStoreError>) -> ()) {
        do {
            
            let cities: [Home.Location.City] = try fetchCitiesSync()
            
            completionHandler(.success(cities))
        } catch (let error) {
            completionHandler(.failure(.cannotFetch(error.localizedDescription)))
        }
    }
    
    func create(city: Home.Location.City,
                completionHandler: @escaping (Result<Home.Location.City,CitiesStoreError>)->()) {
        var city = city
        generateCityID(city: &city)
        
        do {
            var outputCities: [Home.Location.City] = try fetchCitiesSync()
            
            outputCities.append(city)
            
            let data: Data? = try JSONEncoder().encode(outputCities)
            
            UserDefaults.standard.set(data ,forKey: citiesKeys)
            UserDefaults.standard.synchronize()
            
            completionHandler(.success(city))
            
        } catch {
            completionHandler(.failure(.cannotCreate("")))
        }
    }
    
    func delete(id: String,
                completionHandler: @escaping (Result<Home.Location.City,CitiesStoreError>)->()) {
        do {
            var outputCities: [Home.Location.City] = try fetchCitiesSync()
            
            if let id = outputCities.index(where: { $0.id == id }) {
                let removedItem = outputCities.remove(at: id)
                let data: Data? = try JSONEncoder().encode(outputCities)
                UserDefaults.standard.set(data ,forKey: citiesKeys)
                UserDefaults.standard.synchronize()
                completionHandler(.success(removedItem))
            } else {
                completionHandler(.failure(CitiesStoreError.cannotDelete("No Item Found with id = \(id)")))
            }
        } catch {
            completionHandler(.failure(.cannotDelete("")))
        }
        
    }
    
    func clearCities(completionHandler: @escaping (Result<Void,CitiesStoreError>)->()) {
        UserDefaults.standard.removeObject(forKey: citiesKeys)
        UserDefaults.standard.synchronize()
        completionHandler(.success(()))
    }
}
