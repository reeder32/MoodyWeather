//
//  OpenWeatherMapApiConnector.swift
//  MoodyWeather
//
//  Created by Nicholas Reeder on 3/23/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//

enum WeatherError: Error {
    case NetworkError
    case LocationError
}

extension WeatherError {
    var errorDescription: String? {
        switch self {
        case .NetworkError:
            return String.localizedStringWithFormat("There was an error raching the network.")
        case .LocationError:
            return String.localizedStringWithFormat("There was an error getting your location. We'll use your last saved location to get weather.")
        }
    }
}

struct WeatherList: Codable {
    var list: [Weather]
    var cnt: Int
}

struct WeatherTest: Codable {
    var weather: [WeatherArray]
    var wind: Wind
    var clouds: Clouds
    var main: Main
    var id: Int
    var name: String
    var sys: System
    let coord: Coord
    var dt: TimeInterval
    var visibility: Int
}
struct Weather: Codable {
    var weather: [WeatherArray]
    var wind: Wind
    var clouds: Clouds
    var main: Main
    var id: Int
    var name: String
    var sys: System
    let coord: Coord
    var dt: TimeInterval
    var visibility: Int
    var index: Int?
}

struct Coord: Codable {
    var lat: Double
    var lon: Double
}

struct Clouds: Codable {
    var all: Int
}
struct System: Codable {
    var country: String
    var id: Int?
    var sunrise: TimeInterval
    var sunset: TimeInterval
    var type: Int?
}
struct Main: Codable {
    var feels_like: Double
    var humidity: Int
    var pressure: Int
    var temp: Double
    var temp_max: Double
    var temp_min: Double
}
struct Wind: Codable {
    var gust: Double?
    var deg: Int?
    var speed: Double
}
struct WeatherArray: Codable {
    var description: String
    var icon: String
    var id: Int
    var main: String
}
struct Moon: Codable {
    let Age: Double
    let AngularDiameter: Double
    let Distance: Double
    let DistanceToSun: Double
    let Error: Double
    let ErrorMsg: String
    let Illumination: Double
    let Index: Double
    let Moon: [String]
    let Phase: String
    let SunAngularDiameter: Double
    let TargetDate: String
}

import Foundation

struct OpenWeatherMapApiConnector {
    private static let apiKey = "37603cd38b2fe49515989e842c3379de"
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    let defaults = UserDefaults.standard
    
    
    func getWeatherForIds(_ ids: [String], completion: @escaping(_ weatherList: WeatherList?,_ error: Error?) -> Void) {
        let idString = ids.joined(separator: ",")
        print(idString)
        if  let url = URL(string: "http://api.openweathermap.org/data/2.5/group?id=\(idString)&APPID=\(OpenWeatherMapApiConnector.apiKey)") {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let data = data, error == nil {
                    let weatherList = try? self.decoder.decode(WeatherList.self, from: data)
                    completion(weatherList, nil)
                } else {
                    completion(nil, error)
                    print(error as Any)
                    
                }
            }
            task.resume()
        }
    }
    
    func getWeatherForCurrentLocation(with lat: Double?, lon: Double?, completion: @escaping(_ weather: Weather?, _ error: Error?) -> Void) {
        guard let lat = lat else { completion(nil, nil); return }
        guard let lon = lon else { completion(nil, nil); return }
        if let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&APPID=\(OpenWeatherMapApiConnector.apiKey)") {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data, error == nil {
                    
                    let weather = try? self.decoder.decode(Weather.self, from: data)
                    if let encoded = try? self.encoder.encode(weather) {
                        self.defaults.set(encoded, forKey: UserDefaultsKeys.RecentWeather.rawValue)
                    }
                    completion(weather, nil)
                } else {
                    completion(nil, error)
                }
            }
            task.resume()
        }
    }
    
    func getWeatherWithLocationID(locationID: Int, completion: @escaping(_ weather: Weather?, _ error: Error?) -> Void) {
        
        if  let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?id=\(locationID)&APPID=\(OpenWeatherMapApiConnector.apiKey)") {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data, error == nil {
                    
                    let weather = try? self.decoder.decode(Weather.self, from: data)
                    if let encoded = try? self.encoder.encode(weather) {
                        self.defaults.set(encoded, forKey: UserDefaultsKeys.RecentWeather.rawValue)
                    }
                    
                    completion(weather, nil)
                } else {
                    completion(nil, error)
                    print(error as Any)
                    
                }
            }
            task.resume()
        }
    }
    
    func getMoonData(_ lat: Double?, _ lon: Double?, _ completion: @escaping(_ moon: [Moon]?, _ error: Error?) -> Void) {
        guard let lat = lat, let lon = lon else {
            return
        }
       
        if let url = URL(string: "http://api.farmsense.net/v1/moonphases/?d=\(Int(Date().timeIntervalSince1970))&lat=\(lat)&lon=\(lon)") {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    return
                }
            
                let moon = try? self.decoder.decode([Moon].self, from: data)
                if moon?.first?.ErrorMsg != "success" {
                    completion(nil, error)
                } else {
                    if let encoded = try? self.encoder.encode(moon?.first) {
                        self.defaults.set(encoded, forKey: UserDefaultsKeys.RecentMoon.rawValue)
                    }
                    completion(moon, nil)
                }
            }
            task.resume()
        }
    }
    // need to pay for this. Maybe sub option
    //    func getForecast(_ lat: Double?, _ lon: Double?, completion: @escaping(_ weather: Weather?, _ error: Error?) -> Void) {
    //        guard let lat = lat else { completion(nil, nil); return }
    //        guard let lon = lon else { completion(nil, nil); return }
    //        if let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast/hourly?lat=\(lat)&lon=\(lon)&APPID=\(OpenWeatherMapApiConnector.apiKey)") {
    //            let request = URLRequest(url: url)
    //            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    //                if let data = data, error == nil {
    //                    let jsonData = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
    //                    print(jsonData)
    //
    //                }
    //            }
    //            task.resume()
    //        }
    //    }
    //
    //    func getWeatherWithZipCode(zipCode: String?, completion: @escaping(_ weather: Weather?, _ error: Error?) -> Void) {
    //
    //        guard let zipCode = zipCode else { completion(nil, nil); return }
    //        if  let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?zip=\(zipCode),us&APPID=\(OpenWeatherMapApiConnector.apiKey)") {
    //            let request = URLRequest(url: url)
    //
    //            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    //                if let data = data, error == nil {
    //                    let weather = try? self.decoder.decode(Weather.self, from: data)
    //                    completion(weather, nil)
    //
    //                } else {
    //                    completion(nil, error)
    //                }
    //            }
    //            task.resume()
    //        }
    //
    //    }
}
