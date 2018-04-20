//
//  AddNewLocationWorkerTests.swift
//  Weather
//
//  Created by Ahmed Ali Henawey on 20/04/2018.
//  Copyright (c) 2018 Ahmed Ali Henawey. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import Weather
import XCTest
import CoreLocation

class AddNewLocationWorkerTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: AddNewLocationWorker!
    var mockDataSource: MockCityDataSource!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupAddNewLocationWorker()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupAddNewLocationWorker()
    {
        mockDataSource = MockCityDataSource()
        sut = AddNewLocationWorker(dataSource: mockDataSource)
    }
    
    // MARK: Test doubles
    class MockCityDataSource: CitiesStoreProtocol, CitiesStoreUtilityProtocol {
        
        fileprivate var cities: [String: Home.Location.City] = [:]

        var createIsCalled: Bool = false
        
        func fetch(completionHandler: @escaping (Result<[Home.Location.City], CitiesStoreError>) -> ()) {
        }
        
        func create(city: Home.Location.City, completionHandler: @escaping (Result<Home.Location.City, CitiesStoreError>) -> ()) {
            var city = city
            generateCityID(city: &city)
            cities[city.id!] = city
            createIsCalled = true
            completionHandler(.success(city))
        }
        
        func delete(id: String, completionHandler: @escaping (Result<Home.Location.City, CitiesStoreError>) -> ()) {
        }
        
        func clearCities(completionHandler: @escaping (Result<Void, CitiesStoreError>) -> ()) {
        }
        
    }
    // MARK: Tests
    
    func testAddCity()
    {
        // Given
        let expect = expectation(description: "Wait Until Add")
        let coordinates = CLLocationCoordinate2D(latitude: 52.336081, longitude: 4.887131)
        let city = Home.Location.City(name: "Mobiquity", coordinates: coordinates)
        // When
        sut.addCity(city: city) { _ in
            expect.fulfill()
        }
        self.waitForExpectations(timeout: 1)
        // Then
        assert(mockDataSource.createIsCalled, "Add City Called as expected")
    }
    
    func testAddCityFailed()
    {
        // Given
        let expect = expectation(description: "Wait Until Add")
        let coordinates = CLLocationCoordinate2D(latitude: 190, longitude: 190)
        let city = Home.Location.City(name: "Mobiquity", coordinates: coordinates)
        // When
        sut.addCity(city: city) { _ in
            expect.fulfill()
        }
        self.waitForExpectations(timeout: 1)
        // Then
        assert(mockDataSource.createIsCalled == false, "Add City Called as expected")
    }
}
