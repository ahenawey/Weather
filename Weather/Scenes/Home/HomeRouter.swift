//
//  HomeRouter.swift
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

@objc protocol HomeRoutingLogic
{
    func routeToDetails(segue: UIStoryboardSegue?)
    func routeToAddNewLocation(segue: UIStoryboardSegue?)
}

protocol HomeDataPassing
{
    var dataStore: HomeDataStore? { get }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing
{
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?
    
    // MARK: Routing
    
    func routeToAddNewLocation(segue: UIStoryboardSegue?) {
        if let segue = segue {
            let destinationVC = segue.destination as! AddNewLocationViewController
            destinationVC.interactor?.delegate = viewController?.interactor
        }
    }
    
    func routeToDetails(segue: UIStoryboardSegue?)
    {
          if let segue = segue {
            let destinationVC = segue.destination as! WeatherDetailsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToDetails(source: dataStore!, destination: &destinationDS)
          }
    }
    
    // MARK: Passing data
    
    func passDataToDetails(source: HomeDataStore, destination: inout WeatherDetailsDataStore)
    {
      destination.selectedCity = source.selectedCity
    }
}
