# Weather
## Architecture
 Following [Clean Swift](http://clean-swift.com/) based on Uncle bob [Clean Architecture](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html)

 The Main Life Cycle based on 3 letters
 **VIP**
 ![VIP](http://clean-swift.com/wp-content/uploads/2015/08/VIP-Cycle.png)

**Relation between components (Scene)**
 1. The view controller’s conform the Display logic protocol and has a reference from Business Logic protocol.
 2. The interactor’s conform the Business Logic protocol and has a reference from Presentation Logic protocol.
 3. The presenter’s conform the Presentation Logic protocol and has a reference from Display Logic protocol.

 4. The view controller will configure all the references on initialisation by UIKit.
 5. The interactor's confrom the Data Store Protocol with is the shared data from this scene.
 6. The view controller has a reference that conform routing protocols (Routing Logic & Data Passing)
 7. the interactor has a much as needed of workers.

We’ll create special objects to pass data through the boundaries between the components. This allows us to decouple the underlying data models from the components. These special objects consists of only primitive types such as Int, Double, and String. We can create structs, classes, or enums to represent the data but there should only be primitive types inside these containing entities.

---
 **Responsibility for each component**
 1. **View Controller**
 Handle user interface that the user can interact with, also collects the user inputs.
 2. **Interactor**
 Contains the app’s business logic.
 3. **Worker**
 Handle data processing that may be stored in Core Data or over the network. (Long time or background process).
 4. **Presenter**
 Prepare the data to be view in simplest way or in primitive data type (String, Int,...etc).
 *For Example:* Localization, formatting (Date,Currency,Time,...etc)
 5. **Router**
 prepare the data to be transferred to new view controller by deliver it from the DataStore which it conformed in interactor (Business Logic protocol) in current view controller to the DataStore which it conformed for new view controller.


## Error Handling
### Asynchronous error handling for Workers (Result pattern)
```swift
func fetch(coordinate: CLLocationCoordinate2D,
               useMeteric: Bool,
               completionHandler: @escaping (Result<WeatherDetails.Forecast, WeatherStoreError>) -> ()) {

        ...

        URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            if let error = error {
                completionHandler(.failure(.error(error)))
                return
            }

            guard let data = data,
                let storngSelf = self else {
                completionHandler(.failure(.cannotFetch("empty respose")))
                return
            }

            do{
                let forecast = try storngSelf.parse(data)
                completionHandler(.success(forecast))
            }catch (let error) {
                completionHandler(.failure(.error(error)))
            }
        }.resume()
    }

    func getWeatherForcast(for coordinate: CLLocationCoordinate2D,useMeteric: Bool, completionHandler: @escaping (Result<WeatherDetails.Forecast, WeatherStoreError>) -> ()) {
      fetch(coordinate: coordinate, useMeteric: useMeteric, completionHandler: completionHandler)
    }
```

We have a enum with 2 cases, one for success with associated type, and one for failure with associated error type

And can be used as following
```swift
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
```
Using a switch statement allows powerful pattern matching, and ensures all possible results are covered

## Development and architecture
Clean Swift concepts are rigid, especially namespaces created for every scene, data passing in Request, Response and ViewModel objects, which are rather non-reusable within scene, because they correspond to a specific Request-Response chain. Sometimes Interactor methods doesn’t have to take any arguments. Communication between objects is again based on protocols. and this help to create class spy to test the abstracted functionality for each layer.

Although Clean Swift imposes strict rules, it appropriately divides responsibilities and creates uni-directional cycle. When compared to VIPER, another difference is that now the View Controller itself contacts Router for navigation, which is in my opinion a nice improvement (no routing of navigation request through VIPER’s Presenter).

## Release notes
1. Unit Tests for Home scene and persistence Store with coverage 19.21% of the whole application.
2. The Mobile API layer could be more abstracted by making another layer for Networking layer to be more testable.
3. It's need more time to add the bouns points which the need some updates in Mobile API layer and UI Screen.
