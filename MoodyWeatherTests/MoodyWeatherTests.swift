//
//  MoodyWeatherTests.swift
//  MoodyWeatherTests
//
//  Created by Nicholas Reeder on 3/23/20.
//  Copyright © 2020 Nicholas Reeder. All rights reserved.
//

import XCTest
@testable import MoodyWeather

class MoodyWeatherTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWeather() {
        let weather = Weather(weather: [],
                              wind: Wind(gust: 0.0, deg: 0, speed: 0.0),
                              clouds: Clouds(all: 0),
                              main: Main(feels_like: 0.0, humidity: 0, pressure: 0, temp: 0.0, temp_max: 0.0, temp_min: 0.0),
                              id: 0,
                              name: "",
                              sys: System(country: "", id: 0, sunrise: 0, sunset: 0, type: 0, timezone: 0),
                              coord: Coord(lat: 0.0, lon: 0.0),
                              dt: 0,
                              visibility: 0,
                              index: 0)
        
        var weatherArray = WeatherArray(description: "", icon: "", id: 0, main: "")
        weatherArray.description = "Light Rain"
        XCTAssertEqual(weatherArray.description, "Light Rain")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
