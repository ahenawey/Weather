//
//  HomeInteractor.swift
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

protocol HomeBusinessLogic
{
  func loadBookmarkedLocations(request: Home.Location.Request)
}

protocol HomeDataStore
{
  //var name: String { get set }
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore
{
  var presenter: HomePresentationLogic?
  var worker: HomeWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func loadBookmarkedLocations(request: Home.Location.Request)
  {
    worker = HomeWorker()
    worker?.doSomeWork()
    
    let response = Home.Location.Response()
    presenter?.presentBookmarkedLocations(response: response)
  }
}
