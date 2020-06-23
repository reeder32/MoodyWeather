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
    var visibility: Int?
    var index: Int?
}


struct Moon {

    let city: String?
    let moonPhaseDesc: String?
    let date: String?
    let moonrise: String
    let moonset: String

}

struct MoonData {
    let astronomy : [String: Any]
    var weeklyData : [[String: Any]]? = nil
    mutating func getValues() -> [Moon]? {
        if let weeklyData = astronomy["astronomy"] as? [String: Any] {
            var weeklyMoonData = [Moon]()
            guard let astronomy = weeklyData["astronomy"] as? [[String: Any]] else { return [] }
            astronomy.forEach { object in
                guard let city = object["city"] as? String, let moonPhase = object["moonPhaseDesc"] as? String, let date = object["utcTime"] as? String, let moonrise = object["moonrise"] as? String, let moonset = object["moonset"] as? String else { return }
                let moon = Moon(city: city,
                                moonPhaseDesc: moonPhase,
                                date: date,
                                moonrise: moonrise,
                                moonset: moonset)
                weeklyMoonData.append(moon)
            }
            //print(weeklyMoonData)
            return weeklyMoonData
        } else {
            return []
        }
    }
    
}

import Foundation

// TODO: class
class OpenWeatherMapApiConnector: NSObject {
    static let shared = OpenWeatherMapApiConnector()
    private static let apiKey = "37603cd38b2fe49515989e842c3379de"
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    let defaults = UserDefaults.standard
    private static let baseURL = "http://api.openweathermap.org/data/2.5/"
    var didGetWeatherList: ((WeatherList?, Error?) -> Void)?
    var didGetWeather: ((Weather?, Error?) -> Void)?
    var didGetMoonData: (([Moon]?, Error?) -> Void)?
    var session = URLSession.shared

    func getWeatherForIds(_ ids: [String]) {
        let idString = ids.joined(separator: ",")
        //print(idString)
        if  let url = URL(string: "\(OpenWeatherMapApiConnector.baseURL)group?id=\(idString)&APPID=\(OpenWeatherMapApiConnector.apiKey)") {
            let request = URLRequest(url: url)
            let task = self.session.dataTask(with: request) { [weak self] (data, response, error) in
                //print(data, response, error)
                if let data = data, error == nil {
//                                        let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
//                                        print(jsonData)
                    
                    let weatherList = try? self?.decoder.decode(WeatherList.self, from: data)
                    self?.didGetWeatherList?(weatherList, nil)
                } else {
                    self?.didGetWeatherList?(nil, error)
                    print(error as Any)
                    
                }
            }
            task.resume()
        }
    }
    
    func getWeatherForCurrentLocation(lat: Double?, lon: Double?) {
        guard let lat = lat else { didGetWeather?(nil, nil); return }
        guard let lon = lon else { didGetWeather?(nil, nil); return }
        if let url = URL(string: "\(OpenWeatherMapApiConnector.baseURL)weather?lat=\(lat)&lon=\(lon)&APPID=\(OpenWeatherMapApiConnector.apiKey)") {
            let request = URLRequest(url: url)
            let task = self.session.dataTask(with: request) { [weak self] (data, response, error) in
                //print(data)
                
                if let data = data, error == nil {
//                    let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
//                                       print(jsonData)
                    
                    let weather = try? self?.decoder.decode(Weather.self, from: data)
                    self?.didGetWeather?(weather, nil)
                } else {
                    self?.didGetWeather?(nil, error)
                }
            }
            task.resume()
        }
    }
    
    func getWeatherWithLocationID(locationID: Int, completion: @escaping(_ weather: Weather?, _ error: Error?) -> Void) {
        
        if  let url = URL(string: "\(OpenWeatherMapApiConnector.baseURL)weather?id=\(locationID)&APPID=\(OpenWeatherMapApiConnector.apiKey)") {
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
    
    func calculateMoon(_ lat: Double?, _ lon: Double?, completion: @escaping(_ moonData: [Moon]?, _ error: Error?) -> Void) {
        guard let lat = lat, let lon = lon else {
            return
        }
       
        if let url = URL(string: "https://weather.ls.hereapi.com/weather/1.0/report.json?apiKey=87j3w6HHYAlXjkv3LVsTIKg1RUQnOncBH6eSkiz-IhU&product=forecast_astronomy&latitude=\(lat)&longitude=\(lon)") {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                if let  error = error { completion(nil, error) }
                guard let data = data else { return }
                guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {completion(nil, nil); return }
                    var moonData = MoonData(astronomy: jsonData)
                completion(moonData.getValues(), nil)
                
            }
            task.resume()
        }
    }
        
}
